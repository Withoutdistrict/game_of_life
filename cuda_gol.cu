#include <ostream>
#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <stdexcept>

#include "cuda_gol.h"

// #include <cuda.h>
// #include <cuda_runtime.h>

__global__ void cuda_gol_update(int *A, int *B, int N)
{
    int k = blockIdx.x;
    int i = threadIdx.x;

    // int r = (k / N);
    // int c = (k % N);

    __shared__ int nbh_c;
    if (threadIdx.x == 0)
        nbh_c = 0;
    __syncthreads();

    int nbh_idx_i, nbh_idx_j;

    nbh_idx_i = ((i % 3) - 1) + (k / N);
    nbh_idx_j = ((i + 3) / 3 - 2) + (k % N);

    if (!((nbh_idx_i < 0 || nbh_idx_j < 0) || (nbh_idx_i >= N || nbh_idx_j >= N) || (nbh_idx_i == k && nbh_idx_j == k)))
    {
        if (A[nbh_idx_i * N + nbh_idx_j] == 1)
        {
            atomicAdd(&nbh_c, 1);
        }
    }
    __syncthreads();

    // for (int i = r - 1; i <= r + 1; i++)
    // {
    //     for (int j = c - 1; j <= c + 1; j++)
    //     {
    //         if ((i == r && j == c) || (i < 0 || j < 0) || (i >= N || j >= N))
    //         {
    //             continue;
    //         }
    //         if (A[i * N + j] == 1)
    //         {
    //             if (threadIdx.x == 0)
    //             nbh_c++;
    //         }
    //     }
    // }

    if (A[k] == 1 && (nbh_c == 2 || nbh_c == 3))
    {
        B[k] = 1;
    }
    else if (A[k] == 0 && nbh_c == 3)
    {
        B[k] = 1;
    }
    else
    {
        B[k] = 0;
    }
}

__global__ void cuda_update_objs(int *A, GameObject *physicsObjs, int N)
{
    int k = blockIdx.x;

    if (A[k] == 0)
    {
        physicsObjs[k].color = {0, 0, 0};
    }
    else
    {
        physicsObjs[k].color = {1, 1, 1};
    }
}

void fct_cuda_stat_init(int *A, int **c_A, int *B, int **c_B, int N)
{
    cudaMalloc(c_A, N * N * sizeof(int));
    cudaMalloc(c_B, N * N * sizeof(int));

    cudaMemcpy(c_A[0], A, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(c_B[0], B, N * N * sizeof(int), cudaMemcpyHostToDevice);
}

void fct_cuda_stat_updt(int *A, int *c_A, int *B, int *c_B, int N)
{
    cuda_gol_update<<<N * N, 9>>>(c_A, c_B, N);
    cudaMemcpy(c_A, c_B, N * N * sizeof(int), cudaMemcpyDeviceToDevice);

    // cudaMemcpy(A, c_A, N * N * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(B, c_B, N * N * sizeof(int), cudaMemcpyDeviceToHost);

    memcpy(A, B, N * N * sizeof(int));
}

void fct_cuda_stat_free(int *c_A, int *c_B)
{
    cudaFree(c_A);
    cudaFree(c_B);
}

void fct_cuda_objs_init(std::vector<GameObject> *p_physicsObjs, GameObject **c_physicsObjs, int N)
{
    cudaMalloc(c_physicsObjs, N * N * sizeof(GameObject));
    cudaMemcpy(c_physicsObjs[0], p_physicsObjs->data(), N * N * sizeof(GameObject), cudaMemcpyHostToDevice);
}

void fct_cuda_objs_updt(int *A, int *c_A, std::vector<GameObject> *p_physicsObjs, GameObject *c_physicsObjs, int N)
{
    cuda_update_objs<<<N * N, 1>>>(c_A, c_physicsObjs, N);

    cudaMemcpy(p_physicsObjs->data(), c_physicsObjs, N * N * sizeof(GameObject), cudaMemcpyDeviceToHost);
}

void fct_cuda_objs_free(GameObject *c_physicsObjs)
{
    cudaFree(c_physicsObjs);
}