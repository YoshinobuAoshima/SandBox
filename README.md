# buildコマンド
docker compose up -d --build

# 環境変数一覧
以下環境変数をRepository secretsに設定してください

APP_ENV : (本番環境)production / (開発環境)local
DOMAIN : yourdomain.com
MYSQL_DATABASE : yourdatabase
MYSQL_USER : youruser
MYSQL_PASSWORD : yourpassword
MYSQL_ROOT_PASSWORD : yourrootpassword
TZ : yourtimezone

VPS_HOST : yourvphost
VPS_SSH_KEY : yoursshkey
VPS_USER : youruser
