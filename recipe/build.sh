#!/bin/bash
set -exo pipefail

export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

if [[ ${target_platform} == "linux-"* ]]; then
    CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_SHARED_LIBS=ON -DPINCH_BUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF"

    if [[ ${build_platform} != ${target_platform} ]]; then
        CMAKE_ARGS="${CMAKE_ARGS} -DTEST_STD_CHRONO_FROM_STREAM_R=ON"
    fi
elif [[ ${target_platform} == "osx-"* ]]; then
    # Test code is not written for mac
    CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_SHARED_LIBS=ON -DPINCH_BUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF"
fi

cmake -S . -B build ${CMAKE_ARGS}
cmake --build build --parallel ${CPU_COUNT}
cmake --install build

install -m 644 include/pinch/asio.hpp ${PREFIX}/include/pinch/asio.hpp
