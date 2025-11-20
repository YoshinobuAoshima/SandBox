#!/bin/sh

# ドメイン設定
DOMAIN="aoshima-vps.tr-kdev.com"
EMAIL="info@example.com" # 必要に応じて変更
WEBROOT="/var/www/certbot"
TRIGGER_FILE="/var/www/certbot/nginx_reload_trigger"

# 初回待機 (Nginxが起動するのを待つ)
sleep 10

while true; do
    echo "Checking for certificate..."

    # 証明書がCertbotによって管理されているか確認（renewal設定があるか）
    if [ ! -f "/etc/letsencrypt/renewal/$DOMAIN.conf" ]; then
        echo "No existing Certbot certificate found. Requesting new one..."
        
        # ダミー証明書がある場合は削除（Certbotがエラーにならないように）
        rm -rf /etc/letsencrypt/live/$DOMAIN
        
        certbot certonly --webroot -w $WEBROOT \
            -d $DOMAIN \
            --email $EMAIL \
            --agree-tos \
            --no-eff-email \
            --force-renewal
            
        # 取得成功したらリロードトリガーを作成
        if [ $? -eq 0 ]; then
            echo "Certificate obtained successfully."
            touch "$TRIGGER_FILE"
        else
            echo "Certificate request failed."
        fi
    else
        echo "Existing certificate found. Attempting renewal..."
        certbot renew
        
        # 更新があった場合（または強制的に）リロードトリガーを作成
        # certbot renewは更新が必要ない場合は何もしないが、
        # post-hookなどで検知するのが一般的。
        # ここでは簡易的に、renewコマンドが成功したらトリガーを作る（頻度は低いので許容）
        # ただし、renewは更新がなくてもexit 0を返すため、
        # 本当は更新された時だけリロードしたいが、
        # 12時間に1回のリロードなら許容範囲とする。
        touch "$TRIGGER_FILE"
    fi

    # 12時間待機
    echo "Sleeping for 12 hours..."
    sleep 12h
done
