---
title: Ｃ言語プログラミングの基礎訓練
author: 西井 淳
fontsize: 12pt
papersize: a4paper
toc: true
titlepage: false
screen: true
fancy: false
listing: true
geometry: width=14cm, height=19cm
---


プログラム作成上の注意点
========================

1. 以下でプログラムを作る時には，Makefile を作成し，**make コマンドでコンパイル**できるようにする。
2.  言語はC++でもよい。(この場合ファイル入出力の命令は，練習問題中の指定とは異なるC++のストリーム入出力の命令を用いてよい)
3. その他，別冊の「C言語プログラミングの掟」をよく読んでから以下の課題に取り組むこと


準備運動
========================

コンパイル・リンク
------------------

**[問]**
C言語等のプログラムを書いたとき、それを実行できる形式にするには**コンパイル**と**リンク**が必要である。
この「コンパイル」と「リンク」とはどのような作業をすることか説明しなさい。
説明には「プリプロセッサ」，「ヘッダファイル」，「ソースプログラム」,
「オブジェクトファイル」, 「実行形式」というキーワードを使うこと。

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

定数の定義$^(*$
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

main関数への引数の処理$^(*$
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
    `int a[n]`を確保し，全ての$i<n$について `a[i]=i` を代入した後，`a[]`の内容を表示するコマンド`array`をつくりなさい。なお，この節でのプログラムでは以下に気を付けること。

    1.  メモリ確保に失敗したときには，エラー出力を行って終了すること。

    2.  必ず確保したメモリーは必ずプログラム終了時までに開放すること。

2.  引数で整数$n$が与えられたとき，２次元配列`int a[n][n]`を確保し，その配列を単位行列として、 配列`a`の内容を表示するコマンド`array2`をつくりなさい。

ファイル入出力と分割コンパイル
==============================

1.  以下の関数群をつくり，`mylib.c`という名前で保存しなさい。

    1.  引数で指定したファイル名の関数を読込みモードで開き，そのファイルへのファイルポインタを返す関数`fRopen`。
        ファイルを開くのに 失敗したときには、"Failed to open ◯◯" (◯◯には引数で与えたファイル名が入る)と**標準エラー出力**に出力してプログラムを終了。

                FILE* fRopen(char* fname)

    2.  引数で指定したファイル名の関数を書込みモードで開き，そのファイルへのファイルポインタを返す関数`fWopen`。
        ファイルを開くのに失敗したときには、"Failed to open ◯◯"と**標準エラー出力**に出力してプログラムを終了。

                FILE* fWopen(char* fname)

2.  `mylib.c`の中の関数のプロトタイプ宣言(関数原型宣言)のみを記載したファイル`mylib.h`をつくりなさい。

3.  `make clean`を実行したら，末尾に`~` がついた名前のファイルと拡張子が`.o`であるファイルが削除されるように Makefile を作りなさい。

乱数とデータ処理$^(*$
================

1.  引数で与えた回数だけ0以上1以下の一様乱数を発生し、結果を各行に
    表示するプログラム`genrand`をつくりなさい。
    また，100回乱数を発生させた結果をリダイレクト(UNIX関連のドキュメン
    ト参照)を用いて保存しなさい。

2.  数値データをファイルから読み込み，以下を行うプログラム`getdist`をつくりなさい。
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

    6.  C言語でのオプション処理は通常の文字列処理関数を使って行っても，
    	gccの標準ライブラリ`getopt`を使っても良い。`getopt`の使い方は各自
    	調べること。

    7.  プログラムのはじめのほうで，どのような引数があるかをチェックし，
        引数が不適切な場合には，ただちにUsageを表示して終了する。

    8.  既に作った`mylib.c`にあるファイルを開く関数を利用し、分
        割コンパイルを行うこと。

    9.  `make getdist`を実行すればコマンド`getdist`を出力できるよう
        にMakefileを作りなさい。


4.  `getdist.c`を改造して，マクロ変数FILE([付録](sec:preprocessor)参照)を
    定義しているときにはファイル`result.dat`に結果を出力するようにし，
    定義してないときにはこれまで通り標準出力に結果を表示するようにしなさい。

    **ヒント**：FILEを定義した場合には出力ファイルポインタを指定したファ
    イルに、定義していないときには標準出力(stdin)に設定する。`#ifdef`の分岐は
    一カ所のみですむはず。

<!--
5.  コンパイル時にgccのオプションに, 例えば`-DFILE`を追加すると、
    プログラム中で`#define FILE`とマクロ定義したのと同じ意味になる。
    このことを利用して、`make fgetdist`とすれば、`getdist.c`をコンパイ
    ルして, 結果をファイルに出力するコマンド`fgetdist`を，
    `make getdist`とすれば結果を標準出力する`getdist`を
    作るようにMakefileを修正しなさい。
-->

パイプ(発展課題)
=============

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

数値計算
=========

1.  微分方程式$\dot{x}=x$について以下を行いなさい。

    1.  微分方程式の解を（解析的に）求めなさい。また，その解の挙動のグラフを書きなさい。

    2.  オイラー法により微分方程式の解($x(t)$)を数値計算により求めるプログラム`napier.c`を作成し，それをもとに自然定数$e$を求めなさい。

2. 質量$m$の物体を地表から角度$\theta$上方に初速度$v_0$で投げた時の軌道を計算したい。
    1. 物体の運動方程式を書きなさい。
    2. オイラー法による数値計算により，物体の軌道を求めるプログラム`trajectory.c`。数値計算のプログラムは以下のようにすること。ただし，重力加速度の大きさは$g=9.8$ m/s$^2$とする。
        - 質量，角度，初速度は引数で与えるようにする。
        - その他の各種パラメータは静的変数として，ヘッダ部で定義する。
        - 計算終了は物体が地面に落下した時とする。
    3. 質量5 kgの物体を45$^\circ$上方に初速度100 km/hrで投げた時，どれだけ遠くに届くかを求めなさい。ただし空気抵抗は無視できるとし，
        - 離散計算で得られる値と，理論値を比べ，どの程度の精度で計算できるかを調べること。
        - 離散計算の時間刻みを変えた時に，その精度がどの程度変化するかも確認しなさい。

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

このドキュメントの著作権について
================================

1.  本稿の著作権は西井淳[nishii@sci.yamaguchi-u.ac.jp](nishii@sci.yamaguchi-u.ac.jp)が有します。

2.  非商用目的での複製は許可しますが，修正を加えた場合は必ず修正点および加筆者の
    氏名・連絡先，修正した日付を明記してください。また本著作権表示の削除は行っ
    てはいけません。

3.  本稿に含まれている間違い等によりなんらかの被害を被ったとしても著者は一切
    責任を負いません。

間違い等の連絡や加筆修正要望等の連絡は大歓迎です。
