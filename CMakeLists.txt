cmake_minimum_required(VERSION 3.21)

#set(CMAKE_VERBOSE_MAKEFILE ON)
#set(VERBOSE ON)

project(game_of_life LANGUAGES CXX C CUDA)

set(AUTHOR "Eugene Sanscartier")
set(AUTHOR_DETAILS "eugene.sanscartier@umontreal.ca")
set(DESCRIPTION "Conway's Game of Life.")

find_package(glfw3 REQUIRED)

find_package(Vulkan REQUIRED)
include_directories(${Vulkan_INCLUDE_DIRS})
message("-- Vulkan_INCLUDE_DIRS: " ${Vulkan_INCLUDE_DIRS})

# find_package(CUDA REQUIRED)
# include_directories(${CUDA_INCLUDE_DIRS})
# message("-- CUDA_INCLUDE_DIRS: " ${CUDA_INCLUDE_DIRS})

add_library(cuda_gol STATIC cuda_gol.cu)
target_compile_features(cuda_gol PUBLIC cxx_std_11)
set_target_properties(cuda_gol PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
target_compile_options(cuda_gol PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-Xcudafe="--diag_suppress=20012">)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(cuda_gol PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-G>)
    message("Debug CUDA with $<$<COMPILE_LANGUAGE:CUDA>:-G>")
endif()

# target_compile_options(cuda_gol PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-G>)

set(SOURCE render_app.cpp renderer.cpp)
add_executable(game_of_life main.cu ${SOURCE})
target_link_libraries(game_of_life glfw vulkan cuda_gol)

set_target_properties(game_of_life PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
target_compile_options(game_of_life PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-Xcudafe="--diag_suppress=20012">)
# target_compile_options(game_of_life PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-G>)
















