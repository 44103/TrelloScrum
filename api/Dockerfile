# pythonの3.8.0をベースにする
FROM python:3.8.0

RUN apt update \
    && apt -y upgrade \
    && apt -y install locales \
    && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
    && apt -y install vim \
    # imageのサイズを小さくするためにキャッシュ削除
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    # pipのアップデート
    && pip install --upgrade pip

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9

# 作業するディレクトリを変更
WORKDIR /workdir/lambda

COPY requirements.txt ${PWD}

# pythonのパッケージをインストール
RUN pip install -r requirements.txt -t /workdir/lambda

# 作業するディレクトリを変更
# コンテナの内部には入った際のディレクトリの位置を変更している
WORKDIR /workdir/api