# 本番環境デプロイ時要変更点

- docker/app/Dockerfile
  - COPY ./docker/app/php-dev.ini /usr/local/etc/php/php.ini
  - →COPY ./docker/app/php-prod.ini /usr/local/etc/php/php.ini