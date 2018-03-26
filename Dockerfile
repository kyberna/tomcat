FROM tomcat:8-jre8
LABEL maintainer="Seti <sebastian.koehlmeier@kyberna.com>"

ADD node /node

RUN apt-get update && \
    apt-get install -yq --no-install-recommends openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /conf /tlib /tconf /data /deploy && \
    mkdir /node/logs /node/temp /node/webapps /node/work && \
    useradd -u 1000 -m tomcat && \
	chown 1000:1000 /data /deploy /conf /tconf /tlib

ADD run.sh /run.sh
RUN chmod +x /*.sh && chmod o+rx ${CATALINA_HOME} -R && chown 1000:1000 /node -R

ENV CATALINA_BASE /node
ENV CATALINA_TMPDIR $CATALINA_BASE/temp

VOLUME [ "/data", "/conf", "/deploy", "/properties", "/tconf", "/tlib" ]

USER 1000:1000
CMD ["/run.sh"]