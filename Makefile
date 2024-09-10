# Makefile for RazorEnhanced-extension

# Variables
SHELL := $(or $(SHELL),/usr/bin/bash)

# Check if the shell is bash or zsh, otherwise default to bash
SHELL_NAME := $(shell basename $(SHELL))
ifeq ($(filter $(SHELL_NAME),bash zsh),)
    SHELL := /usr/bin/bash
endif

SHELL := /usr/bin/bash
PUBLISHER := razorenhanced
EXTENSION_NAME := razorenhanced
VERSION := 0.0.2
VSIX_FILE := $(EXTENSION_NAME)-$(VERSION).vsix

# Default target
all: npm-install package

# Install dependencies
npm-install:
	@echo "Installing dependencies..."
	npm install ws protobufjs vscode

lint:
	eslint ./extension.js

# Package the extension into a .vsix file
package: npm-install  lint  
	@echo "Packaging the extension into a .vsix file..."
	vsce package 

# Clean the project
clean:
	@echo "Cleaning the project..."
	rm -rf node_modules
	rm -f $(VSIX_FILE)

# Install the extension in VS Code/VSCodium
install: package
	@echo "Installing the extension..."
	code --install-extension $(VSIX_FILE)

# Uninstall the extension
uninstall:
	@echo "Uninstalling the extension..."
	code --uninstall-extension $(PUBLISHER).$(EXTENSION_NAME)

# Open the project in VSCodium
open:
	@echo "Opening the project in VSCodium

protobuf:
	protoc -I ./proto --python_out=./test/ ProtoControl.proto

test: protobuf 
	python3 test/test.py

get-version:
	@node -p "require('./package.json').version"

increment-version:
	@current_version=$$(node -p "require('./package.json').version"); \
	IFS='.' read -ra version_parts <<< "$$current_version"; \
	new_patch=$$((version_parts[2] + 1)); \
	new_version="$${version_parts[0]}.$${version_parts[1]}.$$new_patch"; \
	sed -i 's/"version": "'$$current_version'"/"version": "'$$new_version'"/' package.json; \
	echo "$$new_version" > .version

tag-version:
	@new_version=$$(cat .version); \
	git add package.json; \
	git commit -m "Bump version to $$new_version"; \
	git tag v$$new_version; \
	git push && git push --tags
