cmake_minimum_required(VERSION 3.2.0 FATAL_ERROR)
project(mr4c)

set(CMAKE_CXX_FLAGS "$CMAKE_CXX_FLAGS -std=c++11")

include_directories(api)

file(GLOB_RECURSE MR4C_SOURCES impl/*)

add_library(${PROJECT_NAME} SHARED ${MR4C_SOURCES})
target_link_libraries(${PROJECT_NAME} liblog4cxx.so libjansson.so)