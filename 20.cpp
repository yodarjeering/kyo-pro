#include <iostream>
#include <cmath>
// #include <bits/stdc++.h>
using namespace std;
using ll = long long;

// pow 使うとエラー
// なぜ？
int main(void){

    ll a,b,c;
    cin>>a>>b>>c;
    ll z=1;

    for (int i=0;i<b;i++){
        z*=c;
    }

    // z = pow(c,b);


    if(a < z){
        cout << "Yes" <<endl;
    }
    else{
        cout << "No" << endl;
    }

    


    return 0;
}