#!/bin/sh

glslc shaders/simple_shader.vert -o shaders/simple_shader.vert.spv
glslc shaders/simple_shader.frag -o shaders/simple_shader.frag.spv

mkdir build/shaders
cp shaders/simple_shader.vert.spv build/shaders/simple_shader.vert.spv
cp shaders/simple_shader.frag.spv build/shaders/simple_shader.frag.spv
