#
import numpy as np
from scipy.linalg import lu

# 1. Define a 3x3 matrix (A)
# We choose a non-singular matrix for a reliable test case
A = np.array([
    [2,  5,  8],
    [5,  2,  2],
    [7,  5,  6]
], dtype=float)

print("--- Original Matrix A ---")
print(A)
print()

# 2. Perform LU Decomposition with Partial Pivoting
# P: Permutation matrix (tracks row swaps for numerical stability)
# L: Lower triangular matrix (with 1s on the diagonal)
# U: Upper triangular matrix
P, L, U = lu(A)

print("--- Permutation Matrix P ---")
print(P)
print()

print("--- Lower Triangular Matrix L ---")
print(L)
print()

print("--- Upper Triangular Matrix U ---")
print(U)
print()

# 3. Verification Step
# Reconstruct the matrix: P * L * U should equal our original A
A_reconstructed = P @ L @ U

print("--- Verification (P * L * U) ---")
print(A_reconstructed)

# Check if they match within floating-point tolerance
assert np.allclose(A, A_reconstructed), "Error: Reconstruction failed!"
print("\nSuccess: P * L * U perfectly matches the original matrix A!")

