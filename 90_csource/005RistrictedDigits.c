#include <stdio.h>

// むずすぎたため、これは飛ばします。

#define MOD 1000000007

int main() {
    long long N, B, K;
    scanf("%lld %lld %lld", &N, &B, &K);
    int c[10];
    for (int i = 0; i < K; i++) {
        scanf("%d", &c[i]);
    }

    long long dp[10001][1000] = {0};
    dp[0][0] = 1;

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < B; j++) {
            if (dp[i][j] == 0) continue;
            for (int k = 0; k < K; k++) {
                int new_mod = (j * 10 + c[k]) % B;
                dp[i + 1][new_mod] = (dp[i + 1][new_mod] + dp[i][j]) % MOD;
            }
        }
    }

    printf("%lld\n", dp[N][0]);
    return 0;
}