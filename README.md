# TrelloScrum
アジャイルのスクラムで開発する際に、Trelloをより使いやすくするためのアプリケーション。  
今回はPythonを使用する。

# 使い方
## コンテナ名変更
docker-compose.ymlファイル内で必要に合わせてコンテナ名を変更する。

## ライブラリ追加
Pythonで使用するライブラリを事前にrequirements.txtファイルに記述する。

## コンテナ起動
```bash
docker-compose up -d --build
```
## コンテナへ接続
```bash
docker-compose exec python3 bash
```

# 参考文献
- [Dockerを使って機械学習の環境を作ろうとした話](https://qiita.com/penpenta/items/3b7a0f1e27bbab56a95f)
- [dockerで簡易にpython3の環境を作ってみる](https://qiita.com/reflet/items/4b3f91661a54ec70a7dc)