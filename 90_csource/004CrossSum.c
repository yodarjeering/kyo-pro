#include <stdio.h>

int main(void){
    int H;
    int W;
    scanf("%d %d", &H, &W);

    int A[H][W];
    int sumRow[H];
    int sumCol[W];

    // sumの配列初期化してないせいでアドレスが入ってた
    for (int i = 0; i < H; i++){
        sumRow[i] = 0;
        for (int j = 0; j < W; j++){
            scanf("%d", &A[i][j]);
            sumRow[i] += A[i][j];
        }
    }

    for(int j=0; j<W; j++){
        sumCol[j] = 0;
        for(int i=0; i<H; i++){
            sumCol[j] += A[i][j];
        }
    }

    for(int i=0; i<H; i++){
        for(int j=0; j<W; j++){
            printf("%d ", sumRow[i] + sumCol[j] - A[i][j]);
        }
        printf("\n");
    }


    return 0;
}

