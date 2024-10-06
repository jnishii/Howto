---
title: GitHub入門
author: 西井淳
fontsize: 11pt
papersize: a4paper
twocolumn: false
listing: true
toc: false
titlepage: false
fancy: false
geometry: width=15cm, height=22cm
---

# GitHubを使う

Gitコマンド等の詳しい説明は西井のホームページに掲載している他，googleで検索したら色々出てくるので，ここにはごく基本的なことのみ紹介。必要に応じて自分で調べること。

## GitHubとは

- **gitとは**: gitは開発中のソースファイルや作成中の文書のバージョン管理システム。もともとはソースコードの共同開発用に作られた。
- **gitサーバ**: リポジトリを一元管理するサーバ。無料サーバとして有名なのに[GitHub](https://github.com/)や[Bitbucket](https://bitbucket.org)がある。
- **リポジトリ**: gitで管理するソースファイルやそのバージョン情報の置き場所のこと
  - **ローカルリポジトリ**: 手元のマシン上にあるリポジトリ
  - **リモートリポジトリ**: Gitサーバ上にあるリポジトリ
  - **公開リポジトリ**:Gitサーバ上のリポジトリのうち，誰でもアクセスできるもの
  - **非公開(プライベート)リポジトリ**:Gitサーバ上のリポジトリのうち，許可されたユーザだけアクセスできるもの
- [GitHub Education](https://education.github.com/): GitHubの無料アカウントは，非公開リポジトリは作れない。しかし，[GitHub Education](https://education.github.com/)に教員や学生が申請すると無料で非公開リポジトリを作れる。


## 準備
### 準備1: アカウント作り

[GitHub](https://github.com/)に無料アカウントを作る。

### 準備2: git コマンドのインストール

git コマンドをローカルマシンにインストールする。

- **Linuxの場合**: apt-get対応のディストリビューションなら
```
$ apt-get install git
```
で大抵OK。

- **Mac OSの場合** : Xcode コマンドラインツールをインストールしていたら，gitコマンドもインストールされている。

### 準備3: 自分のアカウント情報をローカルマシンに登録

```
$ git config --global user.name “あなたの名前”
$ git config --global user.email “あなたのメールアドレス”
$ git config --global core.editor vi      # コメント編集に使いたいエディタを設定(デフォルトはvi)
```

`--global`は，ローカルリポジトリ作成時のデフォルト設定にするためのオプション。

### 準備4: 必要に応じてproxy設定

大学内等，外部とのネットワーク接続にproxy設定が必要な環境の場合は，ターミナルとgitのproxy設定をする。(西井のホームページ参照)

## 研究室関連のドキュメントをダウンロードしてみる

### リポジトリのダウンロード

1. 以下のリポジトリのcloneをダウンロードしてみる
  - bcl-group/Howto.git : 宿題のテキスト等がある
  - bcl-group/bcl-admins.git : インストールマニュアルがある

```
git clone https://github.com/bcl-group/Howto.git
git clone https://github.com/bcl-group/bcl-admins.git
```
ダウンロードしたら中身を確認してみること。

### ダウンロードしてリポジトリに修正を加えてアップロード

ダウンロードしたリポジトリ内のファイルをいじるときには，必ずGitサーバから最新バージョンをダウンロードしてから開始。

```
$ git pull origin master
```

これはサーバ(origin)から，masterブランチ(ブランチは後述)をダウンロードするという意味。

必要に応じてファイルを更新したら，gitサーバ(origin)にアップロードする。
```
$ git add .
$ git commit -m “修正点を少し書く”    <=ローカルリポジトリ(手元)に登録
$ git push origin master           <=リモートリポジトリに反映
```

`git add`は，更新したファイルのうち，リモートリポジトリに反映したいファイルを指定(stagingとよぶ。これにより対象ファイルはstaging areaに移動)する。指定方法は以下のようにいろいろある。

- `git add .`            \hspace{4mm}新規作成ファイルと更新ファイルを全部指定
- `git add <file name>`  \hspace{4mm}特定のファイルを指定 
- `git add -u`           \hspace{4mm}前回から更新したファイルのみ指定<br>(新規作成ファイルは含まない)
- `git add -A .`         \hspace{4mm}新規作成ファイル，更新ファイル，削除ファイル全部指定

### その他

自分用のリポジトリを新規に作ったり，古いバージョンに戻したり等々と色々なことをできますので，
少しづつ調べて覚えましょう。
