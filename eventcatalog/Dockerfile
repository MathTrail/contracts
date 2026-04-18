FROM node:24-alpine AS builder

WORKDIR /app

RUN npm install -g @asyncapi/cli@6.0.0

COPY asyncapi/ ./asyncapi/

RUN asyncapi generate fromTemplate asyncapi/mathtrail-events.yaml @asyncapi/html-template@3.5.6 \
    -o /output --force-write

FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY --from=builder /output /usr/share/nginx/html/observability/eventcatalog
COPY eventcatalog/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
