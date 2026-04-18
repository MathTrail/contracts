FROM node:24-alpine AS builder

WORKDIR /app

RUN npm install -g @asyncapi/cli@6.0.0

COPY asyncapi/ ./asyncapi/

RUN npm install @asyncapi/html-template@3.5.6 \
    && asyncapi generate fromTemplate asyncapi/mathtrail-events.yaml ./node_modules/@asyncapi/html-template \
    -o /output --force-write

FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY --from=builder /output /usr/share/nginx/html/observability/eventcatalog
COPY eventcatalog/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
