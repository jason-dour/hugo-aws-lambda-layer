#!/bin/bash
#
# Script to build the Hugo layer.

# Set the version to be built.
HUGO_VERSION="0.62.2"

# Download URL for the source release.
HUGO_URL="https://github.com/gohugoio/hugo/archive/v${HUGO_VERSION}.tar.gz"

# Download the source.
cd /tmp/repo && \
    curl -o hugo.tar.gz -L ${HUGO_URL} && \
    tar -zxf hugo.tar.gz 
if [ $? -ne 0 ]; then
    echo "error: could not download and untar source files."
    exit 1
fi

# Compile Hugo.
cd hugo-${HUGO_VERSION} && \
    go build -tags 'extended'
if [ $? -ne 0 ]; then
    echo "error: could not build hugo."
    exit 2
fi

# Prepare and build the zip file.
mkdir -p bin && \
    mv hugo bin && \
    zip -r9 ../hugo-${HUGO_VERSION}.zip bin/
if [ $? -ne 0 ]; then
    echo "error: could not build layer zip file."
    exit 3
fi

# Clean up our build environment.
cd /tmp/repo
rm -rf hugo-${HUGO_VERSION} hugo.tar.gz 

# Exit.
exit 0