#!/bin/bash

# Function to get latest version from GitHub API
get_latest_version() {
    curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//'
}

# Use provided version or fetch latest
VERSION=${1:-$(get_latest_version)}

echo "Building PocketBase Docker image with version: v${VERSION}"

# Build and push with version-specific tag
docker buildx build \
    --platform=linux/arm64,linux/amd64 \
    --build-arg VERSION=${VERSION} \
    --tag ghcr.io/unbindapp/pocketbase:v${VERSION} \
    --tag ghcr.io/unbindapp/pocketbase:latest \
    --push \
    .

echo "Successfully built and pushed ghcr.io/unbindapp/pocketbase:v${VERSION}"
