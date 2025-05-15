#!/bin/bash
docker buildx build --platform=linux/arm64,linux/amd64 --tag ghcr.io/unbindapp/strapi-development:v5.12.6 --push .