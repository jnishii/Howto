---
title: Ｃプログラミングの掟とメモ
author: 西井 淳
fontsize: 12pt
papersize: a4paper
toc: true
titlepage: true
screen: true
fancy: false
listing: true
geometry: width=14cm, height=19cm
---

Cプログラミングの掟
========================

1.  原則として**一つの関数単位は1画面程度の大きさを上限**にする
3.  プログラム実行時に，**引数等の不具合で異常終了することが無いように** 十分注意すること。
3.  main関数のお作法
    1.  main関数はあまり長くしない。適宜関数を呼び出し，処理のあらすじがわかるようにする。
    2.  オプション指定の引数があるときには，フラグ変数に記録して，その後はそのフラグ変数を参照して処理する。
    3.  まず引数の数をチェックし，不適切な場合等はプログラムをさっさと終了する。以下は例
	```
        enum {False, True};
        void Usage(){
          puts("Usage: ....... ")
        }

        int main()
        {
          int sflag=False;
          if(引数の数のチェック){
            Usage();
            exit(1);
          }
          if( -s があるか?){
              sflag=True; /* -s があるとき */
          }

          /* プログラムの本文 */
        }
	```
5.  同じような命令をプログラム中のあちこちに書いてはいけない。よく似た処理を2回以上書いてしまってら，関数を作って簡単に書く方法を考える。
6.  Segmentation Fault を起こすプログラムは不可
9.  コンパイラgccを使う時には、オプションに`-Wall -O2`をつける。
      - `-Wall`は，プログラム中で確認が必要なところを表示するオプション。
      - `-O2`は，実行速度を速くするためのオプション。

<!--
    7.  **文字列の読み込みの時**には、**関数 scanf()や
        fscanf(),gets()は使わない。** 理由は以下の通り。

        1.  文字列の読み込み時に最大文字数を指定できないので危険なバグが生じることがある。例えば以下のような例で，20文字以上の文字列を入力すると異常終了をしたり，場合によっては重大なセキュリティホールとなりうる。

                 char buf[20];
                 scanf("%s",buf);

         2.  各行毎に処理を行ったほうが，入力にトラブルがあった時に対処しやすい。(scanf, fscanf は改行を無視して読み込みを行う)

        かわりに，文字列データの読み込みはfgets, sscanf を用いることが多い。
        fgets, sscanf についての仕様は man を参照すること。
        以下は**標準入力(stdin)**から整数と文字列を読みこむ例。

            #define MAXLEN 128
            int i;
            char buf[MAXLEN],name[MAXLEN];
            fgets(buf,MAXLEN,stdin)
            sscanf(buf,"%d %s",&i,name);
-->

Makefile{#sec:makefile}
========================

プログラムをコンパイルする手続き等をMakefileに書いておくとコンパイル
が楽になる。 以下は一番簡単なサンプル。
```
arg: arg.c               # arg を arg.c から作ることを宣言
    gcc -o arg arg.c     # 具体的な作り方（行頭はタブ）

mycat: mycat.c           # mycat を mycat.c から作ることを宣言
    gcc -o mycat mycat.c # 具体的な作り方
```
Makefile中の各行において、記号`#`より後ろはコメントとみなされる。

上記のような内容のMakefileを作り，以下を実行すると，その下に書いている条件がみたされる場合に２行目のコマンドが実行されて，arg コマンドが新しくつくられる。
```
$ make arg
```
-   コマンド arg が現在のディレクトリに存在しない
-   現在のディレクトリにあるコマンド**arg が arg.c よりも古い**

たくさんプログラムを書くときには，ずらずらこのような記述をMakefileに並
べておけばよい。Makefile 中で，変数の定義もできる。
変数の値にアクセスするときには、変数名の頭に記号\$をつける。

```
GCC = gcc
CFLAGS=-Wall -O2
Loadlibs=-lm   # 必要に応じて

main: main.o mycat.o    # main は main.o と mycat.o から作る
        ${GCC} ${CFLAGS} -o $@ main.o mycat.o ${Loadlibs}

arg: arg.o              # arg は arg.o から作る
        ${GCC} ${CFLAGS} -o $@ $@.o ${Loadlibs}

main.o: mycat.h main.c
        ${GCC} ${CFLAGS} -c -o $@ main.c

mycat.o: mycat.c
        ${GCC} ${CFLAGS} -c -o $@ mycat.c

clean:
       rm -f *~ *.o
```

最初の3行はコンパイラをあらわす変数`GCC`, コンパイラに与えるオプション
`CFLAGS`, リンクするライブラリ`Loadlibs`の設定。 各行以降の `${GCC}`,
`${CFLAGS}`, `${Loadlibs}`は， ここで設定された値に置換される。
6行目の`$@` は，5行目の`":"`で区切られた左の文字(この場合はmain)をさす変数。

`make main`を実行すると，Makefile 中の記述のうち， **main
に関する文より下の部分の記述から** main.o と mycat.o
の作り方が参照され，それが自動的に実行される。 main.o
に関する該当箇所を見ると，main.o は，mycat.h, main.c に依存してい
ることがわかる。よって，main.o が無い場合や，mycat.h もしくは main.c が
main.o より新しい場合には，新しく main.o が作られる。

また，上の例では以下を実行するとオブジェクトファイル(`*.o`)や，バック
アップファイル `*~`が消去される。
```
$ make clean
```
このように，Makefileは単にプログラムのコンパイルだけでなく，
ファイルの消去，コピーその他，さまざまに使うことができる。

先の例は以下のように書き直すことができる。
たくさんのプログラムのためのMakefileを書くときにはこちらのほうが楽。

```
GCC = gcc
CFLAGS=-Wall
Loadlibs=

main: main.o mycat.o
    ${GCC} ${CFLAGS} -o $@ main.o mycat.o ${Loadlibs}

arg: arg.o
    ${GCC} ${CFLAGS} -o $@ $@.o ${Loadlibs}

main.o: mycat.h main.c

.c.o :
    ${GCC} ${CFLAGS} -c -o $@ $<

clean:
    rm -f *~ *.o
```
`.c.o`と書いたエントリーは`*.c`から`*.o`を作る一般的な
作り方であることを示す。 例えば mycat.o
はmycat.cから作られるが、その作り方は`.c.o`が参照
されて以下のように解釈される。
```
mycat.o : mycat.c
    ${GCC} ${CFLAGS} -c -o $@ $<
```
ここで`$@` は一行目の : の左の mycat.o に，`$<` は : の右の
mycat.cに置換され，mycat.o をつくる処理が実行される。 main.oはmycat.h と
main.cに依存することが記載されているが、その作成方
法は具体的に書かれてないので`.c.o`が参照される。

プリプロセッサ{#sec:preprocessor}
========================

プリプロセッサとは、C言語等のプログラムの**コンパイル前に**前処理を行うた
めの簡易なプログラム言語である。

## マクロ定義

    #define マクロ名 置換文字列

`#define`を用いて、文字列の置換を行うことができる。

    #define MAX 100

と書けば、この行より下の`MAX`という文字列は、コンパイル前に
`100`に置き換えられる。 以下は例。

    #define MAX 10
    int main(void)
    {
    int i;
    char buf[MAX];
    for (i=0;i<MAX;i++) buf[i]=0;
    }


## マクロ関数定義

マクロ定義を使って関数等の定義もできる。

1.  引数xの二乗を計算するマクロ定義例

        #define sqr(x) ((x)*(x))

    ()がなぜ必要かは各自考えよ。

2.  2つの文字の大きい方を返すマクロ関数定義例

        #define maxof(x,y) ((x>y)?x:y)

3.  与えた回数ループをするマクロ関数定義例

        #define loop(n) for(i=0;i<n;++i)

    ただし、あらかじめ `int i;`が宣言されていることが必要。C++なら変
    数の局所定義もOKなので、以下のようにも出来る。

        #define loop(n) for(int i=0;i<n;++i)

4.  先の例で、ループの変数名も与えるようにした例

        #define loop(i,n) for(i=0;i<n;++i)

マクロ関数定義では、引数の型を意識しなくていいので便利。


## 条件分岐

    #ifdef マクロ名
    ...
    #elif
    ...
    #endif

`#ifdef`を用いて、コンパイルする場所の切替えを行うことができる。
以下の例では、マクロ変数DEBUGを定義しているときには、“デバッグ中”と表
示される。

    #define DEBUG
    int main(void)
    {
    #ifdef DEBUG
    printf("デバッグ中);
    #endif
    }

このようにすればデバッグ中にいろんな情報を表示することもでき
る。また、よく似た、でも少し違うコマンドを作りたいときにも便利。
条件分岐に用いられるマクロ変数には、上記の例のように置換文字列を与えて
なくてもよい。

あるマクロ文字が**定義されてない場合**にのみコンパイルしたい部分
は`#ifndef`を使う。

    #ifndef マクロ名
    ...  //指定したマクロが定義されていないときにコンパイルされる部分
    #endif

さらにマクロ変数の値に応じた分岐も可能である。

    #if マクロ名==値1
    ...
    #elif マクロ名==値2
    ...
    #else
    ...
    #endif

パイプ{#sec:pipe}
========================

UNIX上で，あるファイル(例えばdata.txt)の中身をlessで見たければ，
以下を実行すればよい．

    $ less data.txt

この例のように引数としてファイル名を渡すなら，main関数の引数を用いれば
よい．同様の機能は，パイプ(「UNIXの基本操作」参照)を用いて，以下のよう
に実行することもできる。

    $ cat data.txt |less

cat コマンドは`data.txt`を標準出力に表示するコマンドである．
上の例では，この標準出力への出力を`less`が受け取って処理している．
もう少し正確に言うと，パイプは`cat`からの標準出力を`less`コマンドに対す
る標準入力に切替えている．
この場合`less`は標準入力から`data.txt`の中身を読み込んでいることになる．

以下はパイプ出力を受け取ることができるプログラム例。
```
    ....
    int main(int argc, char **argv)
    {
       char *filename;
       FILE *fp;

       filename=argv[argc-1];       /* 最後の引数をファイル名と思って取得 */

       if ( filename[0]=='-' || argc==1 ) { /* 引数が1個 またはfilenameの
                                          1文字目が'-'(オプション指定)のとき*/
          fp = stdin;
       } else {                     /* ファイル指定あり */
          fp = fopen( filename, "r" );
          if ( fp == NULL ) {
             fprintf( stderr, "'%s'が読み込めません.\n", filename );
             exit(1);               /* 異常終了 */
          }
       }
       ....
    }
```

このドキュメントの著作権について
================================

1.  本稿の著作権は西井淳[nishii@sci.yamaguchi-u.ac.jp](nishii@sci.yamaguchi-u.ac.jp)が有します。

2.  非商用目的での複製は許可しますが，修正を加えた場合は必ず修正点および加筆者の
    氏名・連絡先，修正した日付を明記してください。また本著作権表示の削除は行っ
    てはいけません。

3.  本稿に含まれている間違い等によりなんらかの被害を被ったとしても著者は一切
    責任を負いません。

間違い等の連絡や加筆修正要望等の連絡は大歓迎です。
