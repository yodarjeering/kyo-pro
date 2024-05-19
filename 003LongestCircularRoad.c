#include <stdio.h>
#include <stdlib.h>

/*
    木の直径を求める問題
*/

/*

    所感
        ・nodeのscanの回数で結構てこずった
        ・listやmalloc, calloc, reallocなど使い方をある程度理解できた
        ・dfs2回実行するときに, distance visitedの初期化忘れてて正解できなかった
*/


typedef struct {
    int *edges;
    int capacity;
    int size;
}List;

void init_list(List *graph,int capacity){
    // edgesリストの初期化
    // ひとまずcapacity 
    graph->edges = (int*)malloc(sizeof(int)*capacity);
    graph->capacity = capacity;
    graph->size = 0;
}



void add_list(List *graph, int node){
    if(graph->size == graph->capacity){
        int newCapacity = graph->capacity * 2;
        int* newEdges = (int*)realloc(graph->edges, sizeof(int) * newCapacity);
        if (newEdges == NULL) {
            perror("Failed to allocate memory");
            exit(EXIT_FAILURE);
        }
        graph->edges = newEdges;
        graph->capacity = newCapacity;
    }
    int nodeSize = graph->size++;
    graph->edges[nodeSize] = node;
}

// dfs(graph[0],0,....) みたいな実行の仕方
// graphは双方向に接続情報を持っているため、parentノード情報が必要
// *graph はList型のリストの次元
// したがってedgeメンバなどへのアクセスは、graph[i].edgesなどでアクセスできる
// void dfs(List *graph, int nodeNum, int parent, int *distance, int *visited, int dist){

//     //　子ノードにたどり着いたら、その時点でdist, visited情報は更新してよい
    
//     distance[nodeNum] = dist;
//     visited[nodeNum] = 1; 
//     // i:始点から見た子ノード
//     // graph->sizeはその点の子ノードの数
//     // graph->edges[i]にはその点の子ノードのノード番号が記載されている

//     //printf("dist = %d\t nodeNum = %d\t distance[nodeNum] = %d\n",dist,nodeNum,distance[nodeNum]);
//     for( int i=0; i < graph[nodeNum].size; i++){
        
        
//         nodeNum = graph[nodeNum].edges[i];
//         // graph は双方向故、parentノードに遭遇することがある
//         if (visited[nodeNum]!=1){
//             dist++;
            
//             dfs(graph, nodeNum, nodeNum, distance,visited,dist);
//         }
//     }
// }

void dfs(List *graph, int node, int *distance, int *visited, int dist) {
    visited[node] = 1;
    distance[node] = dist;
    for (int i = 0; i < graph[node].size; i++) {
        int nextNode = graph[node].edges[i];
        if (!visited[nextNode]) {
            dfs(graph, nextNode, distance, visited, dist + 1);
        }
    }
}


int main(void){
    int N;

    if (scanf("%d", &N) != 1) {
        fprintf(stderr, "Error reading input for N\n");
        return 1;  // エラーがあった場合は非ゼロの値でプログラムを終了
    }

    // List型のリストを作成
    // 動的にメモリ確保, N+1にはNull入れる？
    List *graph = (List*)malloc(sizeof(List)*(N+1));

    for(int i=1;i<=N;i++){
        // ひとまずメモリサイズ ＝２で初期化
        // graphは辞書型のように扱うため,配列引数は i=1からスタート
        init_list(&graph[i],2);
    }

    // ここfor分のscanfの回数が違うことに起因するエラーだった。。
    // ノード数がN個あるとしたら, pathの数はN-1, したがってi=0 To N-1
    for(int i=0;i<N-1;i++){
        int a;
        int b;
        if (scanf("%d %d", &a, &b) != 2) {
            fprintf(stderr, "Error reading input for a and b\n");
            return 1;  // エラーがあった場合は非ゼロの値でプログラムを終了
        }
        // Listに値追加
        add_list(&graph[a],b);
        add_list(&graph[b],a);
    }

    // dfsするために必要な道具の準備
    // 始点から探索するため、探索済みNodeを保持するリストvisitedと <= 本門は閉路存在しないからvisitedいらなくね？
    // 始点からの距離を保持するリストdistanceを作成する
    int *visited = (int*)calloc(N+1,sizeof(int));
    int *distance = (int*)calloc(N+1,sizeof(int));
    int dist = 0;

    // リスト型はすでにポインタ型なので&はいらない！
    //dfs(graph,0,0,distance,visited,dist);
    dfs(graph, 1, distance, visited, 0);
    // 探索し終えたので、max(distance) なるindex = node番号を取得する
    int max_dist1 = 0;
    int max_node = 0;
    for( int i=0; i<N+1; i++){
        if (max_dist1<distance[i]){
            max_dist1 = distance[i];
            max_node = i;
        }
        // 同時にdistanceとvisitedも初期化する
        distance[i] = 0;
        visited[i] = 0;
    }



    dfs(graph,max_node,distance,visited,dist);    

    // visited も distanceも初期化してないせいじゃね？

    // 探索し終えたので、max(distance) なるindex = node番号を取得する
    int max_dist2 = 0;
    max_node = 0;
    for( int i=0; i<N+1; i++){
        if (max_dist1<distance[i]){
            max_dist1 = distance[i];
            max_node = i;
        }
    }
    
    int answer = max_dist1 + max_dist2;
    free(graph);
    free(visited);
    free(distance);
    // 求める答えは、最長パス+1
    printf("%d\n",answer+1);

    return 0;

}