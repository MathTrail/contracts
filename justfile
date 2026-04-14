# contracts justfile — buf proto toolchain

# Generate Go code from proto files
generate:
    buf generate

# Lint proto files
lint:
    buf lint

# Check for breaking changes against main branch
breaking:
    buf breaking --against '.git#branch=main'

# Run generate + lint
all: generate lint

# Tidy Go dependencies after generate
tidy:
    go mod tidy

# Full pipeline: generate, lint, tidy
build: generate lint tidy

# Format proto files
fmt:
    buf format -w

# -- CI/CD Contract (called by self-hosted runner) ----------------------------

# Lint proto schemas
ci-lint:
    buf lint

# Check for breaking changes against main branch
ci-test:
    buf breaking --against '.git#branch=main'

# Generate Go code
ci-build:
    buf generate

# -- Image Build --------------------------------------------------------------

# Build and push EventCatalog Docker image
# Called by Skaffold via: just build-push-image
# Uses $IMAGE env var set by Skaffold, or accepts a tag argument.
# CI: uses buildctl via BuildKit sidecar (BUILDKIT_HOST set by runner).
# Local: uses buildah (devcontainer runs --privileged).
build-push-image tag=env("IMAGE", ""):
    #!/bin/bash
    set -euo pipefail
    TAG="{{ tag }}"
    if [ -z "$TAG" ]; then
        echo "Error: no image tag provided (set \$IMAGE or pass as argument)" >&2
        exit 1
    fi
    if [ -n "${BUILDKIT_HOST:-}" ]; then
        buildctl build \
            --frontend dockerfile.v0 \
            --opt filename=eventcatalog/Dockerfile \
            --local context=. \
            --local dockerfile=. \
            --output "type=image,name=${TAG},push=true,registry.insecure=true"
    else
        buildah --storage-driver=vfs bud --log-level=error \
            --file eventcatalog/Dockerfile --tag "$TAG" .
        buildah --storage-driver=vfs push --log-level=error --tls-verify=false "$TAG"
    fi
