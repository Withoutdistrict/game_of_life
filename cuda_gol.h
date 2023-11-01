#ifndef CUDA_GOL_H
#define CUDA_GOL_H

#include <vector>
#include "renderer.hpp"

void fct_cuda_stat_init(int *A, int **c_A, int *B, int **c_B, int N);
void fct_cuda_stat_updt(int *A, int *c_A, int *B, int *c_B, int N);
void fct_cuda_stat_free(int *c_A, int *c_B);

void fct_cuda_objs_init(std::vector<GameObject> *p_physicsObjs, GameObject **c_physicsObjs, int N);
void fct_cuda_objs_updt(int *A, int *c_A, std::vector<GameObject> *p_physicsObjs, GameObject *c_physicsObjs, int N);
void fct_cuda_objs_free(GameObject *c_physicsObjs);

#endif
