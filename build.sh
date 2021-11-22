#!/bin/bash
set -e

HADOOP_VERSION=${1:-3.2.2}
INSTALL_PREFIX=${2:-/usr/local/hadoop-mr4c}

# Package mr4c.jar
mvn clean package -Dhadoop-version=${HADOOP_VERSION}
cp -r target/classes/lib target/*.jar src/main/resources/* ${INSTALL_PREFIX}

# Building & install libmr4c.so
mkdir -p build && cd build && \
    cmake ../src/main/cpp -DCMAKE_BUILD_TYPE=MinSizeRel \
                          -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} && \
    make install
