VERSION ?= $(shell git-rpm-version -v)
RELEASE ?= $(shell git-rpm-version -r)
ifeq ($(RELEASE),1)
# Final release
    DEB_VERSION := "$(VERSION)+atmail"
else
# Pre-release
# Replace dots with plus signs in RELEASE, and add atmail identifier
    DEB_VERSION := "$(VERSION)+atmail~$(subst .,+,$(RELEASE))"
endif


GO_MODULE := ${shell awk '/^module +(.+)/ {print $$2}' go.mod}
GO_VERSION := $(shell awk '/^go +(.+)/ {print $$2}' go.mod)
BUILD_DATE := $(shell date -u '+%Y-%m-%d_%I:%M:%S%p')
GIT_HASH := $(shell git rev-parse HEAD)
BINARY_VERSION = $(shell git describe --always)
PACKAGES = "./cmd/authapi"

SNOWBOARD_VERSION ?= v3.7.3

TARGETARCH ?= amd64

DOC_SRC=doc/index.md
BUILD_ROOT ?= $(PWD)
BUILD_DIR ?= build
GOOS ?= linux
GOARCH ?= $(TARGETARCH)
GOCMD=env GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 GOTOOLCHAIN=auto go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean ./...
GOTEST=$(GOCMD) test ./... -p 1

API_SRC=$(BUILD_DIR)/API.apib
SWAGGER_JSON=$(BUILD_DIR)/swagger.json
DOC_HTML=$(BUILD_DIR)/doc/API.html

ASSETS_DIR=resources

# ssh-agent forwarding for docker for mac
# See https://github.com/docker/for-mac/issues/410
ifeq ($(shell uname -s),Darwin)
	SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
endif

.PHONY: all build pack pkg test build-clean clean rpm doc pb sqlc vuln-check generate
all: pkg

vuln-check:
	go install golang.org/x/vuln/cmd/govulncheck@latest && govulncheck ./...

$(BUILD_DIR)/bin/authapi:
	$(GOBUILD) -ldflags "-w -s -X main.Version=$(BINARY_VERSION) -X main.BuildDate=$(BUILD_DATE) -X main.GitHash=$(GIT_HASH)" -o $(BUILD_DIR)/bin/authapi $(PACKAGES)

build: $(BUILD_DIR)/bin/authapi

test:
	$(GOTEST)

doc: $(DOC_HTML)

$(API_SRC):
	mkdir -p $(BUILD_DIR)
	docker run -t --rm \
	    -v $(BUILD_ROOT):/src \
	    -w /src \
	    -u `id -u`:`id -g` \
	    quay.io/bukalapak/snowboard:$(SNOWBOARD_VERSION) apib -o $(API_SRC) $(DOC_SRC)

$(DOC_HTML): $(API_SRC)
	docker run -t --rm \
		-v $(BUILD_ROOT):/src \
		-w /src \
		-u `id -u`:`id -g` \
		quay.io/bukalapak/snowboard:$(SNOWBOARD_VERSION) html -o $(BUILD_DIR)/doc/API.html -c doc/config.yaml $(BUILD_DIR)/API.apib
	cp doc/*.png $(BUILD_DIR)/doc

swagger: $(SWAGGER_JSON)

$(SWAGGER_JSON): $(API_SRC)
	docker run -t --rm \
		-v $(BUILD_ROOT):/src \
		-w /src \
		-u `id -u`:`id -g` \
		kminami/apib2swagger -i $(API_SRC) -o $(SWAGGER_JSON)

build-clean:
	rm -Rf $(BUILD_DIR)/*
	rm -Rf test-reports/
	rm -f *.rpm
	rm -f API-external.css

clean: build-clean
	$(GOCLEAN)

build: build-clean
	mkdir -p $(BUILD_DIR)/bin && chmod -R 777 $(BUILD_DIR)
	$(GOBUILD) -v -ldflags "-w -s -X main.Version=$(BINARY_VERSION) -X main.BuildDate=$(BUILD_DATE) -X main.GitHash=$(GIT_HASH)" -o $(BUILD_DIR)/bin/authapi $(PACKAGES)

pkg: build
	cp LICENSE $(BUILD_DIR)
	cp LICENSE-3RD-PARTY.txt $(BUILD_DIR)
	cp INSTALL.md $(BUILD_DIR)
	cp UPGRADE.md $(BUILD_DIR)
	cp TechnicalReference.md $(BUILD_DIR)
	cp resources/authapi.yaml $(BUILD_DIR)
	cp resources/atmail-authapi.service $(BUILD_DIR)
	cd $(BUILD_DIR); tar -czf authapi-$(VERSION).tar.gz *

pb:
	buf generate

# sqlc: use sqlc to generate go code from sql schema and commands
sqlc:
	rm -rf sqlc/generated
	mkdir -p sqlc/generated
	go generate ./...
	cd sqlc && sqlc generate

deps:
	go get ./cmd/...

rpm: pkg
	docker run -t --rm \
	    -v "$(BUILD_ROOT)/resources:/srv" \
	    -v "$(BUILD_ROOT):/output" \
	    -v "$(BUILD_ROOT)/$(BUILD_DIR):/src" \
	    -u 0:0 \
	    -e BUILD_VERSION="$(VERSION)" \
	    -e BUILD_RELEASE="$(RELEASE)" \
	    -e BUILD_DATE="$(BUILD_DATE)" \
	    -e PKG_LIST="atmail-authapi" \
	    rpmbuild/centos7

deb: pkg
	rm -Rf $(BUILD_DIR)/authapi-$(VERSION)
	cd $(BUILD_DIR); mkdir -p authapi-$(DEB_VERSION)/debian/source; tar xf authapi-$(VERSION).tar.gz -C authapi-$(DEB_VERSION)/

	# Copy the template files
	PROJECT_NAME=$(PROJECT_NAME) VERSION=$(DEB_VERSION) ARCH=$(TARGETARCH) envsubst < $(ASSETS_DIR)/debian/control.tpl > $(BUILD_DIR)/authapi-$(DEB_VERSION)/debian/control
	PROJECT_NAME=$(PROJECT_NAME) VERSION=$(DEB_VERSION) ARCH=$(TARGETARCH) envsubst < $(ASSETS_DIR)/debian/copyright.tpl > $(BUILD_DIR)/authapi-$(DEB_VERSION)/debian/copyright
	# Delete all tpl files
	find $(BUILD_DIR)/authapi-$(DEB_VERSION)/debian/ -type f -name '*.tpl' -exec rm \{} \;
	# # Copy the rest
	rsync -L -a --exclude '*.tpl' $(ASSETS_DIR)/debian/ $(BUILD_DIR)/authapi-$(DEB_VERSION)/debian/

	# Build the package using debuild
	cd $(BUILD_DIR)/authapi-$(DEB_VERSION) && \
	DEBEMAIL="support@atmail.com" DEBFULLNAME="operations" dch --package authapi --create --newversion "$(DEB_VERSION)" "Automated changelog entry." && \
	debuild -us -uc
	lintian -c --fail-on=warning build/*.deb

generate:
	oapi-codegen -config codegen-config.yaml doc/openapi.yaml
