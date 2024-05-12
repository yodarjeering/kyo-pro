#include <stdio.h>
#include <stdlib.h>

/*
    木の直径を求める問題
*/

// typedef struct {
//     /*
//         int *edges  : 整数型の配列を指す. 隣接している他のノードのIDを持つ

//         int capacity    : edges配列の現在の最大容量を示す

//         int size    : edges配列に格納されている要素の数を示す. 新しいエッジが追加されるたびにこの値を増加させる必要があ
//     */
//     int *edges;
//     int capacity;
//     int size;
// } List;

// // 初期化関数。指定された容量でリストを初期化します。
// void list_init(List *list, int capacity) {
//     list->edges = (int*)malloc(sizeof(int) * capacity);
//     list->capacity = capacity;
//     list->size = 0;
// }

// // リストに要素を追加する関数。容量が不足していれば拡張します。
// void list_add(List *list, int node) {
//     if (list->size == list->capacity) {
//         // メモリを再確保で倍増させていく戦略があるらしい
//         list->capacity *= 2;
//         list->edges = (int*)realloc(list->edges, sizeof(int) * list->capacity);
//     }
//     list->edges[list->size++] = node;
// }

// // リストのメモリを解放する関数。
// void list_free(List *list) {
//     free(list->edges);
//     list->edges = NULL;
//     list->size = 0;
//     list->capacity = 0;
// }

// // 深さ優先探索 (DFS) を行う関数。距離情報を更新しながら探索します。
// void dfs(int node, int parent, List *graph, int *visited, int *distance, int dist) {
//     visited[node] = 1;
//     distance[node] = dist;
//     for (int i = 0; i < graph[node].size; i++) {
//         int next = graph[node].edges[i];
//         if (next != parent) {
//             dfs(next, node, graph, visited, distance, dist + 1);
//         }
//     }
// }

// int main() {
//     int N;
//     scanf("%d", &N);
    
//     // List型変数のメモリ確保
//     List *graph = (List*)malloc(sizeof(List) * (N + 1));

//     for (int i = 1; i <= N; i++) {
//         list_init(&graph[i], 2);
//     }

//     for (int i = 1; i < N; i++) {
//         int A, B;
//         scanf("%d %d", &A, &B);
//         list_add(&graph[A], B);
//         list_add(&graph[B], A);
//     }
//     // ----------------------------
//     printf("graph = %d\n",graph[3].edges[2]);


//     int *visited = (int*)calloc(N + 1, sizeof(int));
//     int *distance = (int*)calloc(N + 1, sizeof(int));
//     // 任意の点（ここでは1）から最も遠い点を見つけるためにDFSを実行
//     dfs(1, -1, graph, visited, distance, 0);
//     int farthest_node = 1;
//     for (int i = 2; i <= N; i++) {
//         if (distance[i] > distance[farthest_node]) {
//             farthest_node = i;
//         }
//     }
//     // 最も遠い点から再びDFSを実行し、最も遠い点までの距離（直径）を求める
//     for (int i = 1; i <= N; i++) {
//         visited[i] = 0;
//     }
//     dfs(farthest_node, -1, graph, visited, distance, 0);
    
//     int diameter = 0;
//     for (int i = 1; i <= N; i++) {
//         if (distance[i] > diameter) {
//             diameter = distance[i];
//         }
//     }
    
//     // 直径に1を加えた値が解答
//     printf("%d\n", diameter + 1);

//     for (int i = 1; i <= N; i++) {
//         list_free(&graph[i]);
//     }
//     free(graph);
//     free(visited);
//     free(distance);

//     return 0;
// }


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

// void add_list(List *graph, int node){
//     int SIZE = graph->size;
//     int CAPACITY = graph->capacity;

//     // edgesリストのサイズが足りなくなった場合, メモリを確保する
//     if(SIZE<CAPACITY){
//         // メモリ再確保 倍増で対応する戦略 by chatGPT
//         CAPACITY *= 2;
//         graph->edges = (int*)realloc(graph->edges, sizeof(int) * CAPACITY);
//         graph->capacity = CAPACITY;
//     }
//     graph->edges[graph->size] = node;
//     graph->size++;
    
// }

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
    graph->edges[graph->size++] = node;
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

void dfs(List *graph, int node, int parent, int *distance, int *visited, int dist) {
    visited[node] = 1;
    distance[node] = dist;
    for (int i = 0; i < graph[node].size; i++) {
        int nextNode = graph[node].edges[i];
        if (!visited[nextNode]) {
            dfs(graph, nextNode, node, distance, visited, dist + 1);
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
    
    for(int i=0;i<N;i++){
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
    dfs(graph, 1, -1, distance, visited, 0);
    puts("here2");
    // 探索し終えたので、max(distance) なるindex = node番号を取得する
    int max_dist = 0;
    int max_node = 0;
    for( int i=0; i<N+1; i++){
        if (max_dist<distance[i]){
            max_dist = distance[i];
            max_node = i;
        }
    }

    dfs(graph,max_node,max_node,distance,visited,dist);    

    // 探索し終えたので、max(distance) なるindex = node番号を取得する
    for( int i=0; i<N+1; i++){
        if (max_dist<distance[i]){
            max_dist = distance[i];
            max_node = i;
        }
    }

    free(graph);
    free(visited);
    free(distance);
    // 求める答えは、最長パス+1
    printf("%d\n",max_dist+1);

    return 0;

}