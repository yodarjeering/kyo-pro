#include <stdio.h>
#include <stdlib.h>

// 2分探索していけばいけそう

int compare(const void *a, const void *b)
{
    return *(int *)a - *(int *)b;
}

int getAbsolute(int a, int b){
    int value = a - b;
    if(value<0){
        value *= -1;
    }
    return value;
}

void binSearch(int left, int right, int *min, int b, int A[]){
    if (left > right) return;

    int center = (left + right) / 2;
    int diff_abs = getAbsolute(A[center], b);

    if (diff_abs < *min) {
        *min = diff_abs;
    }

    if (A[center] < b) {
        binSearch(center + 1, right, min, b, A);
    } else {
        binSearch(left, center - 1, min, b, A);
    }
}

int main(void)
{
    int N;
    scanf("%d", &N);

    int *A = (int *)malloc(N * sizeof(int));  // 動的メモリ割り当てに変更
    for (int i = 0; i < N; i++)
    {
        scanf("%d", &A[i]);
    }

    qsort(A, N, sizeof(int), compare);

    int Q;
    scanf("%d",&Q);

    for (int i = 0; i < Q; i++)
    {
        int b;
        scanf("%d", &b);
        int min = getAbsolute(A[0], b);
        binSearch(0, N - 1, &min, b, A);
        printf("%d\n", min);
    }

    free(A);  // メモリ解放
    return 0;
}