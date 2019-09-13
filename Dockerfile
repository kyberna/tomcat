FROM tomcat:8-jdk8-corretto
LABEL maintainer="Seti <sebastian.koehlmeier@kyberna.com>"

ADD node /node

RUN yum update && \
    yum install -y openssh-clients && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir /conf /tlib /tconf /data /deploy && \
    mkdir /node/logs /node/temp /node/webapps /node/work

ADD run.sh /run.sh

ENV CATALINA_BASE /node
ENV CATALINA_TMPDIR $CATALINA_BASE/temp
ENV UserID=1000
ENV GroupID=1000

VOLUME [ "/data", "/conf", "/deploy", "/properties", "/tconf", "/tlib" ]

CMD ["/run.sh"]