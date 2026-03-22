FROM node:22-alpine AS builder

WORKDIR /app

# Copy eventcatalog config and AsyncAPI specs
COPY eventcatalog/package*.json ./
RUN npm ci

COPY eventcatalog/eventcatalog.config.js ./
COPY asyncapi/ ./asyncapi/

# Generate EventCatalog content from AsyncAPI, then build static site
RUN npm run generate && npm run build

# Serve via nginx under /observability/eventcatalog
FROM nginx:1.27-alpine

COPY --from=builder /app/.eventcatalog/build /usr/share/nginx/html/observability/eventcatalog

COPY eventcatalog/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
