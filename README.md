MySQL レプリケーションデモ環境 (双方向)
====

### ディレクトリ構造
```
.
├── docker （各種Daemon）
│   │
│   ├── mysql1 （マスター）
│   │   ├── conf.d (mysqlの設定ファイル)
│   │   ├── data (mysqlのデータファイル)
│   │   ├── init （mysqlの初期DDL）
│   │   ├── logs （mysqlのログ）
│   │   └── script （mysql関連のスクリプト）
│   └── mysql2 （スレーブ）
│       ├── conf.d (mysqlの設定ファイル)
│       ├── data (mysqlのデータファイル)
│       ├── init （mysqlの初期DDL）
│       ├── logs （mysqlのログ）
│       └── script （mysql関連のスクリプト）
│
└── dc.sh （Dockerの起動用スクリプト）
```

## Description

## Demo

## VS. 

## Requirement

## Usage

```
# サーバーを起動する
$ ./dc.sh start

# サーバーを停止する
$ ./dc.sh stop
```

## Install

```
# 初期化
$ ./dc.sh init
# Dockerイメージ作成＆コンテナ起動
$ ./dc.sh start
# アクセス確認（初回は立ち上がるまで少し時間がかかります）
$ ./dc.sh mysql1 login
$ ./dc.sh mysql2 login
# レプリケーションを設定
$ ./dc.sh mysql2 setslave
$ ./dc.sh mysql1 setslave
```

## Contribution

## Licence

[MIT](https://github.com/isystk/mysql-replication-mutual/LICENCE)

## Author

[isystk](https://github.com/isystk)


