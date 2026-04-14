FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
COPY --from=ghcr.io/mathtrail/platform-env:1 /config/global.env /etc/mathtrail/platform.env

# buf CLI — Protobuf toolchain (lint, breaking change detection, generate)
ARG BUF_VERSION=1.66.1
RUN curl -sSfL \
    "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/buf \
    && chmod +x /usr/local/bin/buf

# Install buildah with fuse-overlayfs for nested container builds
RUN apt-get update \
    && apt-get install -y --no-install-recommends buildah fuse-overlayfs crun \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/containers \
    && printf '[storage]\ndriver = "overlay"\n\n[storage.options.overlay]\nmount_program = "/usr/bin/fuse-overlayfs"\n' \
       > /etc/containers/storage.conf \
    && mkdir -p /home/vscode/.config/containers \
    && cp /etc/containers/storage.conf /home/vscode/.config/containers/storage.conf \
    && chown -R vscode:vscode /home/vscode/.config

# Pre-configure buildah to trust the k3d registry and resolve short image names
ARG K3D_REGISTRY=k3d-mathtrail-registry.localhost:5050
RUN mkdir -p /etc/containers/registries.conf.d && \
    printf '[[registry]]\nlocation = "%s"\ninsecure = true\n' "${K3D_REGISTRY}" \
    > /etc/containers/registries.conf.d/k3d.conf && \
    printf 'unqualified-search-registries = ["docker.io"]\n' \
    > /etc/containers/registries.conf
