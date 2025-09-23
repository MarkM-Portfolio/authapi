package main

import (
	"fmt"
	"os"

	msvr "bitbucket.org/atmaildevbucket/schema-msvr"
)

const filename = "sqlc/generated/mailserver.schema.sql"

//go:generate go run generate.go
func main() {
	fmt.Printf("Generating '%s' file...", filename)
	fileContent := msvr.GetGeneratedSchema()

	err := os.WriteFile(filename, []byte(fileContent), 0o644)
	if err != nil {
		fmt.Println("Error writing generated SQL file:", err)
		return
	}

	fmt.Println("DONE")
}
