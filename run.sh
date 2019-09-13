#!/bin/bash

CATALINA_OPTS="-server"

if [ "$XMX" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Xmx$XMX"
else
    CATALINA_OPTS="$CATALINA_OPTS -Xmx2G"
fi

if [ "$LICENSE" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Dplatform.application.tenant.tenant0.license.file=$LICENSE"
else
    CATALINA_OPTS="$CATALINA_OPTS -Dplatform.application.tenant.tenant0.license.file=/conf/license.lic"
fi

if [ "$DATA" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Duser.datadir=$DATA"
else
    CATALINA_OPTS="$CATALINA_OPTS -Duser.datadir=/data"
fi

if [ "$CONF" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Dplatform.application.properties.external.location=$CONF"
else
    CATALINA_OPTS="$CATALINA_OPTS -Dplatform.application.properties.external.location=/conf"
fi

if [ "$JMX_PORT" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.local.only=false"
    CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
    CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
    CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT"
    CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT"
fi

if [ "$RMI_HOSTNAME" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=$RMI_HOSTNAME"
fi

if [ "$PROPERTIES_PROFILES" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Dplatform.application.properties.profiles.active=$PROPERTIES_PROFILES"
fi

CATALINA_OPTS="$CATALINA_OPTS -XX:+UseConcMarkSweepGC"
CATALINA_OPTS="$CATALINA_OPTS -XX:NewSize=256m"
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxNewSize=256m"
CATALINA_OPTS="$CATALINA_OPTS -XX:+CMSClassUnloadingEnabled"
CATALINA_OPTS="$CATALINA_OPTS -XX:+CMSClassUnloadingEnabled"
CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=DEPLOYMENT"
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Dmail.mime.encodefilename=true"
CATALINA_OPTS="$CATALINA_OPTS -Dmail.mime.decodefilename=true"

if [ "$ADDITIONAL_OPTS" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS $ADDITIONAL_OPTS"
fi

if [ "$DISABLE_DEFAULT_DEPLOY" != "true" ]; then
    rm -rf /node/webapps/*
    rm -rf /node/work/*
    rm -rf /node/temp/*
    rm -rf /node/logs
    rm -rf /data/logs/*

    mkdir /node/webapps/ROOT
    unzip /deploy/*.war -d /node/webapps/ROOT/

    mkdir /data/logs/$(hostname)
    chmod 0777 /data/logs/$(hostname)
fi

if [ -d /node/conftemplate ]; then
    if [ "$SECURE_COOKIE" == "true" ]; then
        cp /node/conftemplate/webhttps.xml /node/conftemplate/web.xml
    else
        cp /node/conftemplate/webhttp.xml /node/conftemplate/web.xml
    fi
elif [ "$SECURE_COOKIE" == "true" ]; then
    echo "============================================================================"
    echo "You need to Upgrade to new Structure (mount /conf, and not /node) to use SECURE_COOKIE Env"
    echo "============================================================================"
fi

if [ "$(ls /tconf | wc -l)" == "0" ] && [ ! -d /node/conf ] && [ -d /node/conftemplate ]; then
    cp -rp /node/conftemplate/* /tconf
fi

if [ "$CLUSTER" == "true" ]; then
    cp -f /tconf/server.cluster.xml /tconf/server.xml
fi

if [ "$(ls /tlib | wc -l)" != "0" ]; then
    cp /tlib/* /node/lib -f
fi

if [ "$ADDITIONAL_SCRIPT" != "" ]; then
    source $ADDITIONAL_SCRIPT
fi

# for backward compatibility
if [ -e /node/init.sh ]; then
    source /node/init.sh
fi

if [ -d /tconf ]; then
    cp -f /tconf /node/conf
fi

export CATALINA_OPTS="$CATALINA_OPTS"
exec ${CATALINA_HOME}/bin/catalina.sh run
