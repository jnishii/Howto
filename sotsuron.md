---
title: 卒論の確認事項と楽しい課題
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

この文書の最新版は以下のURLで参照できます。
- [https://github.com/jnishii/Howto/blob/master/sotsuron.md](https://github.com/jnishii/Howto/blob/master/sotsuron.md)

# 確認事項

-   名前・連絡先(住所・電話・メール)確認
-   アカウント名確認
-   大学院進学・就職希望確認
-   卒論修論発表会について
    -   修論発表会：2/15(木)
    -   卒論発表会：2/20(月)
-   合同お勉強会について
    -   日程:2/26(月)11時頃〜28(水)17時頃
    -   プレゼンについて
-   春休みのお勉強(宿題、計測実験兼計算機演習等)
    -   スケジュール確認(2/27-)
-   研究室でのデューティ(予定)
    -   セミナー、本読み、各種お勉強会等
    -   必要に応じて物理・数学等の講義出席
-   宿題(後述)
-   卒論の生活
    - 研究室所属後の生活は、普通の社会生活に準じます。言い替えると大学の講義期間とは無関係ですので、公式の夏休み等はありません。休暇は社会生活の常識の範囲内と考えましょう。
    - 休むなという意味ではありません。休むときにはしっかり休みましょう。

# 楽しい課題

## GitHubを使う

GitHub/Gitの使い方は西井のホームページ参照して，以下を実行しましょう。

### テキスト等の入手

- GitHubにアカウントを作って，西井に連絡する
- 以下のリポジトリのcloneをつくる
  - bcl-group/bcl-admins.git : インストールマニュアル等がある
  - jnishii/Howto.git : 西井のテキスト集。宿題のテキスト等がある
```
git clone https://github.com/bcl-group/bcl-admins.git
git clone https://github.com/jnishii/Howto.git
```

### 一度ダウンロードしたリポジトリを最新にする
```
$ cd <リポジトリ名>
$ git pull origin master
```

### ダウンロードしたファイルを修正した時

以下でGitHubに反映する。ただし，リポジトリによっては修正権限が無い場合もある。
そのときにはpull requestをするが，その説明はここでは省略。
```
$ cd <リポジトリ名>
$ git add .
$ git commit -m "修正点についての説明を簡単に書く"
$ git push orign master
```

## Linuxの環境作り

- ダウンロードしたインストールマニュアル(bcl-admins/install.pdf)を参考にして，自分のパソコンにLinuxをインストールする
- プログラムを作るためのエディタを決める。
  - Atom, Sublime Text, emacs, vi その他，使いやすいものを早めに決めて，インストールする。(あとで変更してもいいですが)
  - Atom, Sublime Textについての簡単な説明は西井のホームページにもある

## 楽しいお勉強

1. 以下を印刷する。どれもリポジトリHowtoにあるもの。
  - unix.pdf : UNIX/LINUXの基本操作($*$印がついてないセクションを読む)　<= 印刷済み
  - unix-lesson.pdf : UNIX演習
  - (近日中に追加を連絡します)
2. 各演習をどんどんする

## その他

来週の合同お勉強会のあとに，春のお勉強について追加連絡します。
