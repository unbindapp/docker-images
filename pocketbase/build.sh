#!/bin/bash
docker buildx build --platform=linux/arm64,linux/amd64 --tag ghcr.io/unbindapp/pocketbase:v0.28.1 --push .