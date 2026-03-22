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

# Generate Go code + build EventCatalog (verify everything compiles)
ci-build:
    buf generate
    cd eventcatalog && npm ci && npm run build

# -- Image Build --------------------------------------------------------------

# Build and push EventCatalog Docker image
# Usage: just build-push-image <tag>
build-push-image tag=env("IMAGE", ""):
    #!/bin/bash
    set -euo pipefail
    TAG="{{ tag }}"
    if [ -z "$TAG" ]; then
        echo "Error: no image tag provided" >&2
        exit 1
    fi
    buildah --storage-driver=vfs bud --log-level=error \
        --tag "$TAG" eventcatalog/
    buildah --storage-driver=vfs push --log-level=error \
        --tls-verify=false "$TAG"
