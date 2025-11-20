#!/bin/sh

# ドメイン設定
DOMAIN="aoshima-vps.tr-kdev.com"
WEBROOT="/var/www/certbot"
TRIGGER_FILE="/var/www/certbot/nginx_reload_trigger"

# 初回待機 (Nginxが起動するのを待つ)
sleep 10

while true; do
    echo "認証情報を確認しています..."

    # 証明書がCertbotによって管理されているか確認（renewal設定があるか）
    if [ ! -f "/etc/letsencrypt/renewal/$DOMAIN.conf" ]; then
        echo "認証情報が見つかりませんでした。新しい認証情報を取得しています..."
        
        # ダミー証明書がある場合は削除（Certbotがエラーにならないように）
        rm -rf /etc/letsencrypt/live/$DOMAIN
        
        certbot certonly --webroot -w $WEBROOT \
            -d $DOMAIN \
            --register-unsafely-without-email \
            --agree-tos \
            --non-interactive
            
        # 取得成功したらリロードトリガーを作成
        if [ $? -eq 0 ]; then
            echo "認証情報の取得に成功しました。"
            touch "$TRIGGER_FILE"
        else
            echo "認証情報の取得に失敗しました。"
        fi
    else
        echo "認証情報が見つかりました。更新を試みています..."
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
    echo "12時間待機しています..."
    sleep 12h
done
