---
title: Ｃ言語プログラミングの基礎訓練
author: 西井 淳
fontsize: 12pt
papersize: a4paper
toc: true
listing: true
geometry: width=14cm, height=19cm
---


プログラム作成上の注意点
========================

1.  Makefile を作成し，**make コマンドでコンパイル**すること。 Makefile
    の作り方については[付録](sec:makefile)参照。

2.  main 文だけのプログラムは，よほど短いもので無い限り不可。
    **一つの関数単位は1画面程度の大きさを上限**にするのが望ましい。

3.  プログラム実行時に，**引数等の不具合で異常終了することが無
    いように**十分注意すること。

4.  main関数を書くときの注意

    1.  まず引数の数をチェックし，不適切な場合等はプログラムをさっさと終了する。

    2.  オプション指定の引数があるときには，フラグ変数に記録して，
    その後はそのフラグ変数を参照して処理する。

    3.  main関数はあまり長くしない。適宜関数を呼び出し，処理のあらすじ
    がわかるようにする。

    4.  以下はmain関数の構成例
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

5.  同じような命令をプログラム中のあちこちに書いてはいけない。
    繰り返し実行する命令は関数にする。

6.  実行のしかたによって Segmentation Fault を起こすプログラムは不可

8.  言語はC++でもよい。(この場合ファイル入出力の命令は，練習問題中の指
    定とは異なるC++のストリーム入出力の命令を用いてよい)

9.  コンパイラgccを使う時には、オプションに`-Wall -O2`をつける。
    `-Wall`は，プログラム中で確認が必要なところを表示するオプション。
    `-O2`は，実行速度を速くするためのオプション。

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

準備運動
========

コンパイル・リンク
------------------
**[問]**
C言語等のプログラムを書いたとき、それを実行できる形式にするには
**コンパイル**と**リンク**が必要である。
この「コンパイル」と「リンク」とはどのような作業をすることか説明しなさ
い。
説明には「プリプロセッサ」，「ヘッダファイル」，「ソースプログラム」,
「オブジェクトファイル」, 「実行形式」というキーワードも使うこと。

変数とポインタ
--------------

以下の各プログラムを実行したとき、各変数のための記憶領域がメモリ空間で
どのように確保されて値の受け渡しが行われ，結果はいかに表示されるかを説
明しなさい。

**問1**

    #include <stdio.h>
    int z=1;

    void func(int *x)
    {
      static int y=8;
      extern int z;
      printf("%d,%d,%d\n",(*x)++,y++,z++);
    }
    int main(void)
    {
      int x=2,y=5,z=4;
      func(&y);
      printf("%d,%d,%d\n",x++,y++,z++);
      func(&z);
      printf("%d,%d,%d\n",x++,y++,z++);
      return(0);
    }

**問2**

    #include <stdio.h>

    void func(int n1, int *np2)
    {
      n1=*np2;
      *np2=8;
      np2=&n1;
    }

    int main(void)
    {
      int n1=0, n2=5;
      int *np1, *np2, *tmp;

      np1=&n2;
      n2++;
      tmp=&n1;
      (*tmp)++;
      np2=tmp;
      (*tmp)++;

      printf("n1=%d, n2=%d, *np1=%d, *np2=%d\n", n1, n2, *np1, *np2);

      func(*np1,np2);
      printf("*np1=%d, *np2=%d\n", *np1, *np2);
    }

基本
====

定数の定義
----------

定数はプリプロセッサ([付録](#sec:preprocessor)参照)を使って

    #define MAX 10

と定義する方法と、constを使って以下のように定義する方法がある。

    const int MAX=10;

`#define`は**プログラムのコンパイル前に単なる文字列置換として実行**され、
`const`を用いて宣言した変数は**プログラムの実行時にメモリ領域が確保**
される。 このような特徴のため，それぞれ長所と短所がある。

1.  上述した`#define`と`const`の仕様を厳密に満たすコンパイラにより以下
    のプログラムをコンパイルすると、値が正常に表示されない。
    その理由を述べ、修正方法を2通り(`#define`を使う方法と
    `const`を使う方法)を述べなさい。

        #include <stdio.h>
        #define MIN -2
        int main(void)
        {
            printf("%d",3/MIN);
        }

2.  下記のプログラムをコンパイルするとコンパイルエラーが出たり、
    コンパイルは出来ても実行時に配列`a`の値がおかしくなる等の
    不具合が出ることがある。 配列の大きさはコンパイル時に決まっていな
    いといけないことに注意し，なぜこのような不具合が起きるか説明しな
    さい。また，`#define`を使ってプログラムを修正しなさい。

        #include <stdio.h>
        const int MAX=3;
        int main(void)
        {
            int a[MAX],i;
            for(i=0;i<MAX;i++) a[i]=0;
            ...
        }


doubleとfloatの演算
-------------------

1.  `double x=0.0`に0.1を10回足した値は1.0にならない．
    いったいどの程度その値は違うのだろう？ またその理由はなにか？

2.  前問で `double` のかわりに `float` を用いた場合について，同様のことを議論せよ．

3.  以下のプログラムを作ったところ暴走してしまった．修正案を考えなさい。

        #include <stdio.h>

        int main(void)
        {
          double x=0.0;
          while(1) {
            x+=0.1;
          if(x==1.0) break;
          }

          return(0);
        }

4.  `x=0.1`を0.1倍してから10.0倍するという演算を何度か繰り返す
    場合に付いて，`x`が double の場合と float の場合でどのくらい演
    算時間の差があるかを調べよ。プログラムの実行時間はtimeコマンドで計測
    できる(`$ time <command name>`)。

**コメント**) 結果は処理系によって違うが，`double`と`float`の演算にかかる時間は同じになる処理系も多い。
また、`float`は精度が非常に悪いため、メモリ量が少ないとき以外には`float`はほとんど使われない。

main関数への引数の処理
----------------------

1.  プログラムに与えた引数の数と，引数を表示するプログラム`showarg`を作りなさい。 実行結果の例は以下の通り。

    ```
    $ ./showarg a b c
    4
    ./showarg a b c
    ```

2. 引数として与えた2つの実数の和を出力するプログラムを作りなさい。
        (`$ ./sum 1 2` と実行すれば”3”と表示されるプログラム)。引数が2個与えられなかったときには，以下のようなメッセージを出して終了すること。

	```
	$ ./sum 1
	Usage: sum <num1> <num2>
	```

注）main関数への引数は全て文字列として受け取られる。文字列を`double`に変換するには関数 `atof()` を用いる。


動的なメモリ確保
----------------

1.  引数で整数$n$が与えられたとき，`calloc` を用いて配列
    `int a[n]`を確保し，全ての$i<n$について `a[i]=i` を代入した後，
    `a[]`の内容を表示するコマンド`array`をつくりなさい。
    なお，この節でのプログラムでは以下に気を付けること。

    1.  メモリ確保に失敗したときには，エラー出力を行って終了すること。

    2.  必ず確保したメモリーは必ずプログラム終了時までに開放すること。

2.  引数で整数$n$が与えられたとき，２次元配列`int a[n][n]`を確保し，その配列
    を単位行列として、 配列`a`の内容を表示するコマンド`array2`をつくり
    なさい。

ファイル入出力と分割コンパイル
==============================

1.  以下の関数群をつくり，`mylib.c`という名前で保存しなさい。

    1.  引数で指定したファイル名の関数を読込みモードで開き，そ
        のファイルへのファイルポインタを返す関数`fRopen`。
        ファイルを開くのに 失敗したときには、"Failed to open
        ◯◯"(◯◯には引数で与えたファイル名が入る)と**標準エラー出力**に
        出力してプログラムを終了。

                FILE* fRopen(char* fname)

    2.  引数で指定したファイル名の関数を書込みモードで開き，そ
        のファイルへのファイルポインタを返す関数`fWopen`。
        ファイルを開くのに失敗したときには、"Failed to open
        ◯◯"と**標準エラー出力**に出力してプログラムを終了。

                FILE* fWopen(char* fname)

2.  `mylib.c`の中の関数のプロトタイプ宣言(関数原型宣言)のみを記
    載したファイル`mylib.h`をつくりなさい。

3.  `make clean`を実行したら，末尾に`~` がついた名前のファイルと
    拡張子が`.o`であるファイルが削除されるように Makefile を作りなさい。

乱数とデータ処理
================

1.  引数で与えた回数だけ0以上1以下の一様乱数を発生し、結果を各行に
    表示するプログラム`genrand`をつくりなさい。
    また，100回乱数を発生させた結果をリダイレクト(UNIX関連のドキュメン
    ト参照)を用いて保存しなさい。

2.  数値データをファイルから読み込み，以下を行うプログラム`getdist`を
    つくりなさい。
    ただし，以下の仕様を満たすこと。

    2.  `-h`オプションもしくは、オプションが不適切なときには，使
        い方(Usage)を以下のように表示して終了する。

            $ ./getdist -h
              Usage: getdist [option] <file>
              option:
              -h) Show this message
              -n) with line number
              ...(適宜追加)...

    3.  `-a` オプションでデータの平均，標準偏差，最小値，最大値を表示

    4.  `-g` オプションでデータのヒストグラムを出力(設定した刻み幅で,
        度数頻度を’\*’を使って表示する)。例えば設定した刻みを0.1にし
        た場合には

                 0-0.1:   **
                 0.1-0.2: ****
                 0.2-0.3: ***
                 ...

        といった表示を行えるようにする。刻み幅の数は`#define`で用い
        て定義することにより，可変にする。

    5.  引数に `-n` オプションが指定されたときには各行に行番号をつける。

    6.  C言語でのオプション処理は通常の文字列処理関数を使って行っても，
    	gccの標準ライブラリ`getopt`を使っても良い。`getopt`の使い方は各自
    	調べてください。

    7.  プログラムのはじめのほうで，どのような引数があるかをチェックし，
        引数が不適切な場合には，ただちにUsageを表示して終了する。

    8.  既に作った`mylib.c`にあるファイルを開く関数を利用し、分
        割コンパイルを行うこと。

    9.  `make getdist`を実行すればコマンド`getdist`をコンパイルできるよう
        にMakefileを作りなさい。


4.  `getdist.c`を改造して，マクロ変数FILE([付録](sec:preprocessor)参照)を
    定義しているときにはファイル`result.dat`に結果を出力するようにし，
    定義してないときにはこれまで通り標準出力に結果を表示するようにしなさい。

    **ヒント**：FILEを定義した場合には出力ファイルポインタを指定したファ
    イルに、定義していないときには標準出力に設定する。`#ifdef`の分岐は
    一カ所のみですむはず。

5.  コンパイル時にgccのオプションに, 例えば`-DFILE`を追加すると、
    プログラム中で`#define FILE`とマクロ定義したのと同じ意味になる。
    このことを利用して、`make fgetdist`とすれば、`getdist.c`をコンパイ
    ルして, 結果をファイルに出力するコマンド`fgetdist`を，
    `make getdist`とすれば結果を標準出力する`getdist`を
    作るようにMakefileを修正しなさい。


パイプ
------

1.  関数`fRopen`をパイプ([付録](sec:pipe)参照)に対応できるように
    した関数`fRPopen`を作り, `mylib.c`, `mylib.h`に追加しなさい。

2.  パイプを用いてデータファイルを受け取れるように，前問で作成した
    `getdist`を改良した`getdist2`を作りなさい。その動作は以下を試して
    確認しなさい。
    ```
    $ genrand 100 | getdist2
    $ genrand 100 | getdist2 -g
    $ getdist2 <file name>
    $ getdist2 -g <file name>
    ```

微分方程式
----------

1.  微分方程式$\dot{x}=x$について以下を行いなさい。

    1.  微分方程式の解を（解析的に）求めよ。
        その解の挙動のグラフを書き，そのようなグラフの得られる理由について
        考察せよ。

    2.  微分方程式の解($x(t)$)を求めるプログラムを作成し，それをもとに
        自然定数$e$を求めよ。


2. 質量$m$の物体を地表から角度$\theta$上方に初速度$v_0$で投げた時の軌道を計算したい。

  1. 物体の運動方程式を書きなさい。
  2. 数値計算により，物体の軌道を求めなさい。数値計算のプログラムは以下のようにすること。
    - 各パラメータ値は静的変数として，ヘッダ部で定義する。
    - 離散計算の時間刻みも静的変数としなさい。
    - 計算終了は物体が地面に落下時にすること。
  3. 離散計算により得られる物体の軌道や落下までの時間は，運動方程式から解析的に得られる解とどの程度一致するか調べなさい。時間刻みを変えた時に，その精度がどう変化するかも確認しなさい。

<!--
2.  以下の微分方程式について各演習を行いなさい。 $$\begin{aligned}
    \frac{d}{dt}
        \left(\begin{array}[h]{c}
         x\\y
        \end{array}\right)
      =
        \left(\begin{array}[h]{cc}
         0 & 1\\
         -1 & 0
        \end{array}\right)
        \left(\begin{array}[h]{c}
         x\\y
        \end{array}\right)\notag
      \end{aligned}$$

    1.  微分方程式の解を（解析的に）求めよ。
        その解の挙動のグラフを書き，そのようなグラフの得られる理由について考察せよ。

    2.  微分方程式の解($(x(t),y(t)$)を求め，結果をグラフ表示するプログラムを作成せよ。
        結果のグラフ表示の方法は別途説明する。
-->

解説
====

Makefile{#sec:makefile}
--------

プログラムをコンパイルする手続き等をMakefileに書いておくとコンパイル
が楽になる。 以下は一番簡単なサンプル。

    arg: arg.c               # arg を arg.c から作ることを宣言
        gcc -o arg arg.c     # 具体的な作り方（行頭はタブ）

    mycat: mycat.c           # mycat を mycat.c から作ることを宣言
        gcc -o mycat mycat.c # 具体的な作り方

Makefile中の各行において、記号`#`より後ろはコメントとみなされる。

上記のような記述をしたMakefileをつくっておき，以下を実行すると，以下の
場合に２行目のコマンドが実行されて，arg コマンドが新しくつくられる。

        $ make arg

-   コマンド arg が現在のディレクトリに存在しない

-   現在のディレクトリにあるコマンド**arg が arg.c よりも古い**

たくさんプログラムを書くときには，ずらずらこのような記述をMakefileに並
べておけばよい。Makefile 中で，変数の定義もできる。
変数の値にアクセスするときには、変数名の頭に記号\$をつける。

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

最初の3行はコンパイラをあらわす変数`GCC`, コンパイラに与えるオプション
`CFLAGS`, リンクするライブラリ`Loadlibs`の設定。 各行以降の `${GCC}`,
`${CFLAGS}`, `${Loadlibs}`は， ここで設定された値に置換される。
6行目の`$@` は，5行目の`":"`
で区切られた左の文字(この場合はmain)をさす変数。

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

`.c.o`と書いたエントリーは`*.c`から`*.o`を作る一般的な
作り方であることを示す。 例えば mycat.o
はmycat.cから作られるが、その作り方は`.c.o`が参照
されて以下のように解釈される。

    mycat.o : mycat.c
            ${GCC} ${CFLAGS} -c -o $@ $<

ここで`$@` は一行目の : の左の mycat.o に，`$<` は : の右の
mycat.cに置換され，mycat.o をつくる処理が実行される。 main.oはmycat.h と
main.cに依存することが記載されているが、その作成方
法は具体的に書かれてないので`.c.o`が参照される。

プリプロセッサ{#sec:preprocessor}
--------------

プリプロセッサとは、C言語等のプログラムの**コンパイル前に**前処理を行うた
めの簡易なプログラム言語である。

### マクロ定義

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


### マクロ関数定義

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


### 条件分岐

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
----------------

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