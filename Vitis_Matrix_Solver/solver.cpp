#include "solver.hpp"
 
// Function to solve Ax = b using LU Decomposition
void solve_linear_1000(data_t A_in[N*N], data_t b_in[N], data_t x_out[N]) {
    // Map ports to AXI4-Master for efficient burst transfer from DDR
    #pragma HLS INTERFACE m_axi port=A_in offset=slave bundle=gmem
    #pragma HLS INTERFACE m_axi port=b_in offset=slave bundle=gmem
    #pragma HLS INTERFACE m_axi port=x_out offset=slave bundle=gmem
    #pragma HLS INTERFACE s_axilite port=return bundle=control
// Local On-Chip Memory (BRAM/URAM)
    // We use URAM for the large matrix to save standard BRAM
    data_t A[N][N];
    #pragma HLS BIND_STORAGE variable=A type=ram_2p impl=uram
    
    data_t b[N];
    data_t x[N];
// 1. Load Data from DDR to On-Chip RAM
    Load_A: for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            #pragma HLS PIPELINE II=1
            A[i][j] = A_in[i * N + j];
        }
        b[i] = b_in[i];
    }
// 2. LU Decomposition (In-place)
    // Complexity O(N^3), but pipelined
    LU_Outer: for (int k = 0; k < N; k++) {
        // Division step
        LU_Divide: for (int i = k + 1; i < N; i++) {
            #pragma HLS PIPELINE II=1
            A[i][k] /= A[k][k];
        }
        // Elimination step
        LU_Eliminate: for (int i = k + 1; i < N; i++) {
            for (int j = k + 1; j < N; j++) {
                #pragma HLS PIPELINE II=1
                A[i][j] -= A[i][k] * A[k][j];
            }
        }
    }
// 3. Forward Substitution (Ly = b) -> result stored in 'b'
    Forward_Sub: for (int i = 0; i < N; i++) {
        for (int j = 0; j < i; j++) {
            #pragma HLS PIPELINE II=1
            b[i] -= A[i][j] * b[j];
        }
    }
// 4. Backward Substitution (Ux = y) -> result stored in 'x'
    Back_Sub: for (int i = N - 1; i >= 0; i--) {
        data_t sum = 0;
        for (int j = i + 1; j < N; j++) {
            #pragma HLS PIPELINE II=1
            sum += A[i][j] * x[j];
        }
        x[i] = (b[i] - sum) / A[i][i];
    }
// 5. Stream result back to DDR
    Store_X: for (int i = 0; i < N; i++) {
        #pragma HLS PIPELINE II=1
        x_out[i] = x[i];
    }
}


