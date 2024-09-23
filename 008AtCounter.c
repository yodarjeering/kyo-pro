#include <stdio.h>

/*
方針
1. 文字'a'の数と文字列S中のインデックスを数える (他の文字についても同様)
2. indexA < indexT < ... < indexRの条件を満たすものの数をカウント
3. 10**9 + 7で割った数が答え

*/

struct {
    int count;
    int *array;
}List;

void initList(List *list, int N ){
    list->count = 0;
    list->array = (int *)malloc(sizeof(int) * N);
}

int main(void){
    int N;
    sccanf("%d",&N);
    
    int ROWS = 7; // "Atcoder"の7文字分
    List list[ROWS];
    for(int i=0;i<ROWS;i++){
        initList(&list[i]);
    }

    for(int i=0;i<N;i++){
        char S;
        scanf("%s",&S);
        
        switch(S){
            case 'a':
                
                break;
            case 't':
                break;
            case 'c':
                IndexList[2][i] = 1;
                break;
            case 'o':
                IndexList[3][i] = 1;
              break;
            case 'd':
                IndexList[4][i]
        }

    }
    

}