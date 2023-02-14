#!/bin/bash

CATALINA_OPTS="-server -Djava.locale.providers=COMPAT,SPI"

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

#GC
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseStringDeduplication"

#other default ky2 settings
CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=DEPLOYMENT"
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Dmail.mime.encodefilename=true"
CATALINA_OPTS="$CATALINA_OPTS -Dmail.mime.decodefilename=true"

if [ "$ADDITIONAL_OPTS" != "" ]; then
    CATALINA_OPTS="$CATALINA_OPTS $ADDITIONAL_OPTS"
fi

if [ "$ADDITIONAL_SCRIPT" != "" ]; then
    source $ADDITIONAL_SCRIPT
fi

export CATALINA_OPTS="$CATALINA_OPTS"
exec ${CATALINA_HOME}/bin/catalina.sh run
