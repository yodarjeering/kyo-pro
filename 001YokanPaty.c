#include <stdio.h>
#include <stdlib.h>

// 与えられた長さで分割できるかどうかをチェックする関数
// int is_possible(int length, int K, int N, int L, int A[]) {
//     int count = 0, last_cut = 0;

//     for (int i = 0; i < N; i++) {
//         // 現在の切れ目から前回の切れ目までの長さが指定された長さ以上の場合
//         if (A[i] - last_cut >= length && L - A[i] >= length) {
//             count++;
//             last_cut = A[i];
//         }
//     }

//     // 分割したピースの数が K+1 以上なら true
//     return count >= K;
// }

// int main() {
//     int N, L, K;

//     // N, L, K を入力
//     scanf("%d %d %d", &N, &L, &K);
//     int A[N];

//     // 切れ目の位置を入力
//     for (int i = 0; i < N; i++) {
//         scanf("%d", &A[i]);
//     }

//     // 二分探索
//     int low = 0, high = L, mid, answer = 0;
//     while (low <= high) {
//         mid = (low + high) / 2;
//         if (is_possible(mid, K, N, L, A)) {
            
//             answer = mid;  // 現在のmid値を保持
//             low = mid + 1; // より大きな値を探索
//         } else {
//             high = mid - 1; // より小さな値を探索
//         }
//         printf("is_possible : %d\n",is_possible(mid, K, N, L, A));
//     }

//     // 結果を出力
//     printf("%d\n", answer);
//     return 0;
// }


/*
    以下 GPTくんの解説

    この問題は、バイナリサーチ（二分探索）を使用して効率的に解くことができます。基本的な考え方は、ようかんを切る最小の長さを徐々に増やしていき、その長さでK+1ピースに分割できるかどうかを確認することです。分割できる最大の長さが求めるスコアとなります。

    以下に具体的なアルゴリズムを示します：

    初期化: 最小のピースの長さを二分探索で決定するために、探索範囲の下限（low）を0、上限（high）をLとします。

    二分探索: low と high の中間点を計算し（mid）、この長さでようかんをK+1ピースに分割できるかを確認します。分割できる場合は、low をmid + 1に更新し、そうでない場合は high をmid - 1に更新します。

    繰り返し: このプロセスを low <= high の間続けます。

    結果の出力: 最終的に high が求める最大スコアになります。

    これをC言語のコードに落とし込むと以下のようになります：



    思考のプロセスも教えてくれた

1. 解説1
    このような問題を解く際の思考プロセスを詳しく説明します。まず、問題の種類を理解し、それから適切なアルゴリズムや手法を選択することが重要です。この問題は「最適化問題」と見なすことができ、特定の制約の下で最大値または最小値を見つけることが目的です。

    問題の分析
    問題の理解: 問題文をよく読み、何を求められているのかを理解します。この場合、最も短いピースの最大長を見つけることが目標です。

    制約の確認: 制約を確認して、どのようなアプローチが適切かを考えます。ここでは、KとNの最大値が比較的大きい（100000まで）ことから、O(N log N) またはそれ以下の複雑度を持つアルゴリズムが必要です。

    可能なアプローチの検討: この問題では、直接的なアプローチ（すべての可能な分割を試す）は非効率的です。そこで、より効率的な方法としてバイナリサーチが考えられます。

    アルゴリズムの選択
    バイナリサーチの適用性: バイナリサーチは、ソート済みの配列での検索や、特定の条件を満たす最小値または最大値を見つけるのに適しています。この問題では、最大の「最小のピース長」を見つける必要があり、これはバイナリサーチの典型的な用例です。

    問題への適応: スコア（最も短いピースの長さ）を最大化する必要があります。そのため、特定の長さで分割可能かどうかをチェックし、可能な限りその長さを増やす方向でバイナリサーチを行います。

    実装の詳細: バイナリサーチを実装するには、探索範囲の初期値（この場合は0とL）、中間点の計算、および条件（この場合は特定の長さでK+1ピースに分割できるか）に基づく範囲の更新が必要です。

    実装とテスト
    コードの実装: 上記のロジックに基づいてコードを実装します。

    テストケースでの検証: いくつかのテストケースでコードを実行し、期待される結果が得られるかを確認します。

    このように、問題を分析し、適切なアルゴリズムを選択し、問題に合わせてアルゴリズムを適応させるプロセスを踏むことが、この種のプログラミング問題を解く鍵です。最初は難しく感じるかもしれませんが、多くの問題を解いて経験を積むことで、このような思考プロセスが自然にできるようになります。


    二分探索がこの問題で最適解を見つけることができる理由は、問題の性質と二分探索の特性に基づいています。この問題では、特定の条件（最も短いピースの長さ）を最大化する必要があります。ここで重要なのは、「ピースの長さ」と「その長さで分割可能か」という関係が単調性（monotonicity）を持っている点です。

2. 解説2
    単調性（Monotonicity）
    問題の単調性は次のように理解できます：

    もし特定の長さ x でようかんをK+1ピースに分割できるなら、長さ x より短いすべての値（x-1, x-2, ..., 1）でも分割が可能です。
    逆に、長さ x で分割できない場合、それより長いすべての値（x+1, x+2, ...）で分割することもできません。
    この単調性が二分探索の適用可能性を決定します。目的は「できるだけ長いピースを作る」ことですが、その最大値を直接計算するのは困難です。しかし、ある長さで分割できるかどうかを試すことは比較的簡単です。

    二分探索の適用
    この単調性を利用して、二分探索を適用します：

    探索範囲の設定: 最小長さ（0または1）と最大長さ（L）を探索範囲として設定します。

    中間点の試験: 範囲の中間点 mid を選び、その長さでK+1ピースに分割できるか試します。

    範囲の更新:

    分割できる場合: mid 以上の長さでも分割できる可能性があるため、探索範囲の下限を mid + 1 に更新します。
    分割できない場合: mid より長い長さでは分割できないため、探索範囲の上限を mid - 1 に更新します。
    最適解の特定: 上記のプロセスを繰り返し、探索範囲が収束するまで続けます。最終的に得られる high（または low - 1）が最大の分割可能な長さとなります。

    まとめ
    このように、問題の単調性を理解し、それを二分探索のプロセスに適用することで、効率的に最適解を見つけることができます。二分探索は、適切な条件下で最大値または最小値を見つける際に非常に効果的な手法です。








自分は最初こう考えた
1. nCk選ぶ
2. 選んだkの差分で最小が題意のscore

    score = min(a[k1]-0,a[k2]-a[k1],...,a[ki]-a[ki-1],L-a[ki])

    nCk * k orderで行けるんじゃないかと思いましたがnCkの返し方がよくわからなくて詰みました


--------------- 最初の自分の回答
int main(void){
    int N, L, K;
    int *a;
    int b[] = {};

    scanf("%d%d",&N,&L);
    scanf("%d",K);
    
    // mallocによるメモリの動的割り当て
    a = (int *)malloc(N * sizeof(int));
    if (a==NULL){
        puts("Memory allocation failed.");
        return 1;
    }
    for(int i=0;i<N;i++){
        scanf("%d",&a[i]);
    }
    


    return 0;
}
*/

int is_possible(int A[],int mid,int K,int N,int L){

    int last_cut = 0;
    int cnt_cut = 1;
    if(A[0]>=mid){
        last_cut = A[0];
        cnt_cut++;
    }
    
    for(int i=1;i<N;i++){
        // ここでリストAを巡回して, midの長さで, LをK分割できるかチェック
        if(A[i]-last_cut>=mid && L - A[i]>=mid){
            cnt_cut++;
            last_cut = A[i];
        }
    }
    return cnt_cut>=K+1;
    // 戻り値はTrue(1) or False(0)
}

int main(void){
    int N,L,K;
    scanf("%d%d%d",&N,&L,&K);

    int A[N];
    for(int i=0;i<N;i++){
        scanf("%d",&A[i]);
    }
    
    int left=0,right=L;
    int mid=(left+right)/2;
    int answer = 0;


    while(right-left>=0){

        // midの更新タイミングが違った
        // 判定の前に更新する必要がある
        mid = (left+right)/2;
        if(is_possible(A,mid,K,N,L)){
            // Yesのとき, midの長さより長い長さで分割できるかもしれないので, 分割してまた探索
            left = mid + 1;
            answer=mid;
        }
        else{
            // No の時, midでは分割できない
            right = mid - 1;
        }
    }
    printf("%d\n",answer);

    return 0;
}