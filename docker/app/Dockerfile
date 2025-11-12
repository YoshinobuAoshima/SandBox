# イメージをビルドするためのベースイメージを設定
FROM php:8.0-fpm

# コンテナ内のサーバー環境変数を設定
ENV TZ Asia/Tokyo

# コンテナビルド時に実行するコマンド &&で複数のコマンドをつなぎ,\で改行
RUN apt-get update %% \
    # ↑インストール可能なパッケージの一覧を更新、↓必要なパッケージをインストール
    apt-get install -y git unzip libzip-dev livicu-dev libonig-dev && \
    # PHPの拡張ライブラリをインストール
    docker-php-ext-install intl pdo_mysql zip bcmath

    # ローカルで作成したphp.iniをDockerコンテナ内にコピー
    # COPY ローカルパス コンテナパス
    #ローカルパスはDockerfileからではなく、docker buildコマンドを実行したディレクトリ(composer.yml)からの相対パスで指定
COPY ./docker/app/php-dev.ini /usr/local/etc/php/php.ini

# Laravelを使うためComposerをインストール
# マルチステージビルドという方法でインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# exec時の初期ディレクトリを指定
WORKDIR /app