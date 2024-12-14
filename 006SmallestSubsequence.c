#include <stdio.h>
#include <string.h>

void search(int index, int minIndex ,int until,char str[],char ans[]){
    char minChar = str[minIndex];
    int length = strlen(str);
    

    if(until>length){
        ans[index]='\0';
        // printf("%s\n",ans);
        return;
    }
    else{
        // do nothing
    }

    for(int i=minIndex;i<until;i++){
        if(str[i]<minChar){
            minChar=str[i];
            minIndex = i;
        }
    
    }
    ans[index]=minChar;
    until++;
    minIndex++;
    index++;
    search(index,minIndex,until,str,ans);
}


int main( void ){
 
    // int N = 7;
    // int K = 3;
    // char str[] = {"atcoder"};
    int N;
    int K;
    scanf("%d %d",&N,&K);

    char str[ N+1 ];
    char ans[ K+1 ];
    scanf("%s",str);


    int index = 0;
    int minIndex = 0;
    int until = N  - ( K - 1 );

    search( index, minIndex, until, str, ans );
    printf(" %s ", ans);

    return 0;
    }