FROM nginx:1.28-alpine

ENV TZ Asit/Tokyo

COPY ./docker/web/default.conf /etc/nginx/conf.d/default.conf

# Install openssl for dummy cert generation
RUN apk add --no-cache openssl

COPY ./docker/web/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]