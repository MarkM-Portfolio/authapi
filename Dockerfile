FROM golang:latest AS builder
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts
RUN git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"

ARG TARGETARCH=amd64

ENV GOOS=linux
ENV GOARCH=$TARGETARCH
ENV GOCMD="env GOOS=${GOOS} GOARCH=${GOARCH} CGO_ENABLED=0 GOTOOLCHAIN=auto go"


WORKDIR /go/src/app
COPY go.* ./
RUN --mount=type=cache,target=/go/pkg --mount=type=ssh ${GOCMD} mod download
COPY . . 
# RUN ${GOCMD} install golang.org/x/vuln/cmd/govulncheck@latest && \
#     GOTOOLCHAIN=auto govulncheck ./...
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    --mount=type=ssh \
    CGO_ENABLED=0 ${GOCMD} build -o /go/bin/authapi ./cmd/authapi

FROM builder AS authapi-dev-image
RUN --mount=type=cache,target=/var/cache/apt/ apt-get update && apt-get install -y curl jq telnet iputils-ping
# RUN --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=1 go build -o /go/bin/authapi -gcflags="all=-N -l" ./cmd/authapi; \
# go install github.com/go-delve/delve/cmd/dlv@latest
# RUN mkdir -p /etc/atmail/authapi/; touch /etc/atmail/authapi/authapi.yaml /etc/atmail/authapi/email.template
COPY --from=builder /go/bin/authapi /usr/local/bin/authapi
# ENTRYPOINT [ "dlv", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "/go/bin/authapi"]
ENTRYPOINT [ "/usr/local/bin/authapi" ] 

#final stage
FROM ubuntu:24.04 AS authapi-prod-image
RUN --mount=type=cache,target=/var/cache/apt/ apt-get update && \
    apt-get upgrade -y && \
    apt-get full-upgrade -y && \
    apt-get install -y sudo ca-certificates && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*-
RUN groupadd -r atmail && \
    useradd -r -d /usr/local/bin/authapi -s /sbin/nologin authapi && \
    echo authapi ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/authapi && \
    chmod 0440 /etc/sudoers.d/authapi
COPY --from=builder /go/bin/authapi /usr/local/bin/authapi
COPY --from=builder /go/src/app/LICENSE /usr/local/share/atmail/authapi/doc/licenses/LICENSE
COPY --from=builder /go/src/app/LICENSE-3RD-PARTY.txt /usr/local/share/atmail/authapi/doc/licenses/LICENSE-3RD-PARTY.txt
RUN mkdir -p /usr/local/etc/atmail/authapi/; touch /usr/local/etc/atmail/authapi/authapi.yaml /usr/local/etc/atmail/authapi/email.template
USER authapi
ENTRYPOINT [ "/usr/local/bin/authapi", "--config", "/usr/local/etc/atmail/authapi/authapi.yaml" ] 
