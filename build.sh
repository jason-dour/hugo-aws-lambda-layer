#!/bin/bash
#
# Script to build the Hugo layer.

# Prep for build.
CGO_ENABLED=1
GOOS=linux
GOARCH=amd64

# Set the version to be built.
HUGO_VERSION="0.88.1"

# Download URL for the source release.
HUGO_URL="https://github.com/gohugoio/hugo/archive/v${HUGO_VERSION}.tar.gz"

# Basic packages to perform the build.
apk --no-cache add \
    zip curl git gcc g++ \
    musl-dev

# Download the source.
cd /tmp/repo && \
    curl -o hugo.tar.gz -L ${HUGO_URL} && \
    tar -zxf hugo.tar.gz 
if [ $? -ne 0 ]; then
    echo "error: could not download and untar source files."
    exit 1
fi

# Compile Hugo.
cd /tmp/repo/hugo-${HUGO_VERSION} && \
    go build -ldflags '-extldflags "-fno-PIC -static"' -buildmode pie -tags 'extended osusergo netgo static_build'
if [ $? -ne 0 ]; then
    echo "error: could not build hugo."
    exit 2
fi

# Prepare and build the zip file.
zip -r9 ../hugo.zip bin/
if [ $? -ne 0 ]; then
    echo "error: could not build layer zip file."
    exit 3
fi

# Clean up our build environment.
cd /tmp/repo
rm -rf hugo-${HUGO_VERSION} hugo.tar.gz 

# Exit.
exit 0