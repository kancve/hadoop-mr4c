Introduction to the hadoop-mr4c repo
=========

### About hadoop-mr4c

Hadoop-mr4c is an implementation framework that allows you to run native code within the Hadoop execution framework (forked from [google/mr4c](https://github.com/google/mr4c)).
Pairing the performance and flexibility of natively developed algorithms with the unfettered scalability and throughput inherent in Hadoop, 
Hadoop-mr4c enables large-scale deployment of advanced data processing applications.

### Dependencies

* tested with Ubuntu 20.04
* tested with hadoop-2.9.2
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
apt-get install -y liblog4cxx-dev libcppunit-dev libjansson-dev
cd hadoop-mr4c && maven package
cd hadoop-mr4c/src/main/cpp
mkdir build && cd build
cmake .. && make
```


If you get stuck, have questions, or would like to provide *any* feedback, please don’t hesitate to contact us at mr4c@googlegroups.com. 
Let’s do big things together.
