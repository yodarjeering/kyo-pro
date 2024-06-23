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
    else{
        // do nothing
    }
    return value;
}

void binSearch(int center, int *min, int b, int A[]){

    for(int i=0;i<center;i++){
        int diff_abs = getAbsolute(A[center],b);

        if(diff_abs<min){
            *min = A[center];
            center = center/2;
            return binSearch(center,*min,b,A);
        }
    }

}



int main(void)
{
    int N;
    scanf("%d", &N);

    int A[N];
    for (int i = 0; i < N; i++)
    {
        scanf("%d", &A[i]);
    }

    int Q;
    scanf("%d", &Q);

    int B[Q];
    for (int i = 0; i < Q; i++)
    {
        scanf("%d", &B[i]);
    }

    qsort(A,N, sizeof(int),compare);

    for(int i=0;i<N;i++){
        printf("%d ", A[i]);
    }

    return 0;
}