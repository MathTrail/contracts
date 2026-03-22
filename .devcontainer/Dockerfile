FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
COPY --from=ghcr.io/mathtrail/platform-env:1 /config/global.env /etc/mathtrail/platform.env

# buf CLI — Protobuf toolchain (lint, breaking change detection, generate)
ARG BUF_VERSION=1.66.1
RUN curl -sSfL \
    "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/buf \
    && chmod +x /usr/local/bin/buf
