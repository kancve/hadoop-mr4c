Introduction to the hadoop-mr4c repo
=========

### About hadoop-mr4c

Hadoop-mr4c is an implementation framework that allows you to run native code within the Hadoop execution framework (forked from [google/mr4c](https://github.com/google/mr4c)).
Pairing the performance and flexibility of natively developed algorithms with the unfettered scalability and throughput inherent in Hadoop, 
Hadoop-mr4c enables large-scale deployment of advanced data processing applications.

### Dependencies

* tested with Ubuntu 20.04
* tested with hadoop-3.2.2
* java (1.8 min)
* maven (3.6.3 min)
* cmake (3.2.0 min)
* make (3.8.1 min)
* g++ (4.6.3 min)
* log4cxx (0.10.0)
* jansson (2.2.1 min)
* cppunit (1.12.1 min)

### Build

Build with:

```bash
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

```
