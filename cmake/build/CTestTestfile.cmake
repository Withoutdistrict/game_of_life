# CMake generated Testfile for 
# Source directory: /home/eugene/game_of_life/cmake
# Build directory: /home/eugene/game_of_life/cmake/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(particles_10k "/home/eugene/game_of_life/cmake/build/particle_test" "10000")
set_tests_properties(particles_10k PROPERTIES  _BACKTRACE_TRIPLES "/home/eugene/game_of_life/cmake/CMakeLists.txt;35;add_test;/home/eugene/game_of_life/cmake/CMakeLists.txt;0;")
add_test(particles_256k "/home/eugene/game_of_life/cmake/build/particle_test" "256000")
set_tests_properties(particles_256k PROPERTIES  _BACKTRACE_TRIPLES "/home/eugene/game_of_life/cmake/CMakeLists.txt;36;add_test;/home/eugene/game_of_life/cmake/CMakeLists.txt;0;")
