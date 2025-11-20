#!/bin/sh

# ドメイン設定
DOMAIN="aoshima-vps.tr-kdev.com"
CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
TRIGGER_FILE="/var/www/certbot/nginx_reload_trigger"

# 証明書がない場合、ダミー証明書を作成
if [ ! -f "$CERT_DIR/fullchain.pem" ]; then
    echo "$DOMAIN のダミー証明書を作成しています..."
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
        -keyout "$CERT_DIR/privkey.pem" \
        -out "$CERT_DIR/fullchain.pem" \
        -subj "/CN=localhost"
fi

# Nginxをバックグラウンドで起動
echo "Nginxを起動しています..."
nginx -g "daemon off;" &
NGINX_PID=$!

# リロード監視ループ
while true; do
    if [ -f "$TRIGGER_FILE" ]; then
        echo "$DOMAIN のリロードトリガーが検出されました。Nginxを再起動しています..."
        nginx -s reload
        rm -f "$TRIGGER_FILE"
    fi
    sleep 5
done &

# Nginxプロセスが終了したらスクリプトも終了
wait $NGINX_PID
