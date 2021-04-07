#!/bin/bash
set -e

mkdir -p build dist

# Package mr4c.jar
mvn clean package

# Building libmr4c.so
cd build && rm -rf * && \
    cmake ../src/main/cpp -DCMAKE_BUILD_TYPE=Release && make

# Integration target.
cd .. && \
    cp -r target/classes/lib target/*.jar build/*.so dist
