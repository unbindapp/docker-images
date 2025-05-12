#!/bin/bash
docker buildx build --platform=linux/arm64,linux/amd64 --tag ghcr.io/unbindapp/udp2raw:latest --push .