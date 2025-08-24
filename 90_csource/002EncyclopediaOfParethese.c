#include <stdio.h>


int check(int n,int i){

    int count0=0;
    int count1=0;

    for(int j=n-1;j>=0;j--){
        // iをjビット右シフトしたとき
        // 1とアンドを取らないとき, つまり i>>j==1 としてしまうと, (i>>j) == 11 の時,
        // 最下位ビットの1か0かで判別したいのに, false つまり0扱いされてしまい, 正しい結果とならない
        // 最下位ビットの1 or 0 を判別したいときは 論理&を使うこと!!
        if((i>>j)&1){
            // bitが1なら1をカウントする
            count1++;
            // printf("debug1 i = %d\n",i);
        }
        else{
            // bitが0なら0をカウントする
            count0++;
            // printf("debug2 i = %d\n",i);
        }

        if(count0>count1){
            //100011などはありえないためbreak
            // puts("debug 3");
            return 0;
        }
    }

    return count0==count1;
}

void printParenthesis(int n,int i){
    for(int j=n-1;j>=0;j--){
        if((i>>j)&1){
            printf("(");
        }
        else{
            printf(")");
        }
    }
    printf("\n");
}

int main() {
    int n;
    // printf("Enter the length of the parenthesis sequence: ");
    scanf("%d", &n);
    // generateParenthesis(n-1);
    if(n%2!=0) return 0;
    
    for(int i=(1<<n)-1;i>0;i--){
        // puts("------------");
        // printf("debug0 i = %d\n",i);
        // printf("debug8 check(n,i) = %d\n",check(n,i));
        if(check(n,i)){
            // 条件クリアならそのbitをprint
            
            printParenthesis(n,i);
        }
        else{
            // 条件達成していないならば次の値に以降
            continue;
        }
    }

    //printf("debug9 1>>3:  %d\n",1>>3);

    return 0;
}
