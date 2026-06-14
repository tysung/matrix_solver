
#include <iostream>
#include <cmath>
#include "solver.hpp" // Ensure your solver function prototype is here
int main() {
    // 1. Allocate memory for inputs and outputs
    // We use 'static' to avoid stack overflow for large 1000x1000 arrays
    static data_t A[N * N];
    static data_t b[N];
    static data_t x_hw[N];
    static data_t x_sw_ref[N];
// 2. Initialize with a simple test case
    // For a 1000x1000 matrix, we can create a diagonal-dominant matrix
    // to ensure it is solvable without complex pivoting.
    for (int i = 0; i < N; i++) {
        b[i] = (data_t)(i + 1);
        for (int j = 0; j < N; j++) {
            if (i == j)
                A[i * N + j] = (data_t)N * 2; // Large diagonal
            else
                A[i * N + j] = (data_t)1.0 / (i + j + 1);
        }
    }
std::cout << ">> Starting C-Simulation..." << std::endl;
// 3. Call the HLS Hardware Function
    solve_linear_1000(A, b, x_hw);
// 4. Verification (Simple Check)
    // In a real test, you'd solve Ax=b in software to get x_sw_ref
    // For this example, let's check the residual: |Ax - b|
    float max_error = 0.0;
    for (int i = 0; i < N; i++) {
        float row_sum = 0.0;
        for (int j = 0; j < N; j++) {
            row_sum += A[i * N + j] * x_hw[j];
        }
        float error = std::abs(row_sum - b[i]);
        if (error > max_error) max_error = error;
    }
std::cout << ">> Maximum Residual Error: " << max_error << std::endl;
// 5. Conclusion
    if (max_error < 0.001) {
        std::cout << "TEST PASSED!" << std::endl;
        return 0;
    } else {
        std::cout << "TEST FAILED!" << std::endl;
        return 1;
    }
}

