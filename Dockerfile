FROM java:7
MAINTAINER Seti <sebastian.koehlmeier@kyberna.com>

RUN apt-get update && \
    apt-get install -yq --no-install-recommends wget pwgen ca-certificates openssh-client unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /node && \
    mkdir /data && \
    mkdir /deploy && \
	useradd -u 1000 -m tomcat

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.63
ENV CATALINA_HOME /tomcat

ENV CATALINA_BASE /node
ENV DATA /data
ENV DEPLOY /deploy
ENV CATALINA_TMPDIR /$CATALINA_BASE/temp

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat && \
    rm -rf /tomcat/webapps/*

ADD run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 8080
USER 1000:1000
CMD ["/run.sh"]
