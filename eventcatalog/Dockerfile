FROM node:22-alpine AS builder

WORKDIR /app

RUN npm install -g @asyncapi/generator @asyncapi/html-template

COPY asyncapi/ ./asyncapi/

RUN ag asyncapi/mathtrail-events.yaml @asyncapi/html-template \
    -o /output --force-write

FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY --from=builder /output /usr/share/nginx/html/observability/eventcatalog
COPY eventcatalog/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
