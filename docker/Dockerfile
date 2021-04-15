FROM ubuntu:20.04 as build

# install compilation environment
RUN apt-get update && apt-get install -y \
    vim \
    openssh-server \
    gcc \
    g++ \
    cmake \
    make \
    net-tools \
    openjdk-8-jdk-headless \
    liblog4cxx-dev \
    libcppunit-dev \
    libjansson-dev

ARG MAVEN_VERSION=3.6.3
ARG HADOOP_VERSION=3.2.2
ARG MR4C_VERSION=1.0

# install maven
RUN cd /opt && \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} apache-maven

# install hadoop
RUN cd /opt && \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -zxvf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} hadoop && \
    rm -rf hadoop/share/doc

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 HADOOP_HOME=/opt/hadoop MAVEN_HOME=/opt/apache-maven MR4C_HOME=/opt/hadoop-mr4c LANG=C.UTF-8
ENV HADOOP_COMMON_HOME=$HADOOP_HOME HADOOP_HDFS_HOME=$HADOOP_HOME HADOOP_MAPRED_HOME=$HADOOP_HOME HADOOP_YARN_HOME=$HADOOP_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$MAVEN_HOME/bin

# install hadoop-mr4c
RUN cd /opt && \
    wget https://github.com/kancve/hadoop-mr4c/archive/refs/tags/${MR4C_VERSION}.tar.gz && \
    tar -zxvf ${MR4C_VERSION}.tar.gz && \
    mv hadoop-mr4c-${MR4C_VERSION} hadoop-mr4c && \
    cd hadoop-mr4c && \
    chmod -R 755 build.sh && ./build.sh

FROM ubuntu:20.04

MAINTAINER kancve <https://kancve.github.io/>

# install runtime environment
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    openjdk-8-jdk-headless \
    liblog4cxx10v5 \
    libjansson4 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/hadoop-mr4c/dist /opt/hadoop-mr4c
COPY --from=build /opt/hadoop /opt/hadoop

# set environment variable for java & hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 HADOOP_HOME=/opt/hadoop MR4C_HOME=/opt/hadoop-mr4c LANG=C.UTF-8
ENV HADOOP_COMMON_HOME=$HADOOP_HOME HADOOP_HDFS_HOME=$HADOOP_HOME HADOOP_MAPRED_HOME=$HADOOP_HOME HADOOP_YARN_HOME=$HADOOP_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$MR4C_HOME/bin

# Initialize hadoop cluster
RUN mkdir -p /etc/hadoop && \
    ln -s -f $HADOOP_HOME/etc/hadoop /etc/hadoop/conf && \
    ln -s -f $MR4C_HOME/conf /etc/mr4c
