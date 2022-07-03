FROM tomcat:9-jdk8
LABEL maintainer="Seti <sebastian.koehlmeier@kyberna.com>"

ENV CATALINA_BASE /node
ENV CATALINA_TMPDIR $CATALINA_BASE/temp
ENV UserID=1000
ENV GroupID=1000

ADD root /

RUN mkdir /conf /tlib /tconf /data /deploy && \
    mkdir /node/logs /node/temp /node/webapps /node/work && \
    chmod +x /*.sh && \
    groupadd -g ${GroupID} tomcat && \
    useradd -u ${UserID} -g ${GroupID} -m tomcat && \
    apt update && apt install -y unzip && rm -rf /var/lib/apt/lists/*

VOLUME [ "/data", "/conf", "/deploy", "/properties", "/tconf", "/tlib", "/certs" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/run.sh"]