FROM ghcr.io/jimyag/ubuntu:22.04 AS build

COPY java /usr/local/java

ENV JAVA_HOME=/usr/local/java
ENV PATH=$JAVA_HOME/bin:$PATH

RUN java -version
ENTRYPOINT [ "/bin/bash" ]
