#!/bin/bash
set -e

# Load platform environment
set -a; source /etc/mathtrail/platform.env; set +a

# Update buf module dependencies (buf.lock)
buf dep update 2>/dev/null || true

# Install Node dependencies for EventCatalog
cd eventcatalog && npm ci 2>/dev/null || true && cd ..

echo "Contracts environment ready. Run 'just generate' to generate Go code."
