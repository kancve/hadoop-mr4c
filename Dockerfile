ARG VERSION=latest

FROM ubuntu:${VERSION} as builder

# install build environment
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    vim \
    cmake \
    g++ \
    wget \
    openjdk-8-jdk-headless \
    liblog4cxx-dev \
    libcppunit-dev \
    libjansson-dev

ARG MAVEN_VERSION=3.6.3
ARG HADOOP_VERSION=3.2.2

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

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 HADOOP_HOME=/opt/hadoop MAVEN_HOME=/opt/apache-maven MR4C_HOME=/usr/local/hadoop-mr4c LANG=C.UTF-8
ENV HADOOP_COMMON_HOME=$HADOOP_HOME HADOOP_HDFS_HOME=$HADOOP_HOME HADOOP_MAPRED_HOME=$HADOOP_HOME HADOOP_YARN_HOME=$HADOOP_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$MAVEN_HOME/bin:$MR4C_HOME/bin

# install hadoop-mr4c
COPY . /opt/hadoop-mr4c
RUN cd /opt/hadoop-mr4c && \
    chmod -R 755 build.sh && ./build.sh ${HADOOP_VERSION} ${MR4C_HOME}

FROM ubuntu:${VERSION} as dev

# install hdmc dev environment
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    vim \
    cmake \
    g++ \
    gdb \
    git \
    subversion \
    wget \
    openssh-server \
    liblog4cxx-dev \
    libcppunit-dev \
    libjansson-dev

# set environment variable for mr4c & boost
ENV MR4C_HOME=/usr/local/hadoop-mr4c BOOST_ROOT=/opt/boost_1_77_0 LANG=C.UTF-8

# copy mr4c
COPY --from=builder ${MR4C_HOME} ${MR4C_HOME}

# install boost source
RUN cd /opt && \
    wget https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.gz && \
    tar -zxvf boost_1_77_0.tar.gz -C /usr/local && \
    rm boost_1_77_0.tar.gz

ENTRYPOINT [ "/etc/init.d/ssh start" ]

FROM ubuntu:${VERSION}

LABEL author="kancve<https://kancve.github.io/>"

# install runtime environment
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    openjdk-8-jdk-headless \
    liblog4cxx10v5 \
    libjansson4 && \
    rm -rf /var/lib/apt/lists/*

# set environment variable for java & hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 HADOOP_HOME=/opt/hadoop MR4C_HOME=/usr/local/hadoop-mr4c LANG=C.UTF-8
ENV HADOOP_COMMON_HOME=$HADOOP_HOME HADOOP_HDFS_HOME=$HADOOP_HOME HADOOP_MAPRED_HOME=$HADOOP_HOME HADOOP_YARN_HOME=$HADOOP_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$MR4C_HOME/bin

COPY --from=builder ${MR4C_HOME} ${MR4C_HOME}
COPY --from=builder ${HADOOP_HOME} ${HADOOP_HOME}

# Initialize hadoop cluster
RUN mkdir -p /etc/hadoop && \
    ln -s -f $HADOOP_HOME/etc/hadoop /etc/hadoop/conf && \
    ln -s -f $MR4C_HOME/conf /etc/mr4c && \
    chmod -R 755 $MR4C_HOME/bin
