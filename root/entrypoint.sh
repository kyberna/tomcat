#!/bin/bash

usermod -u ${UserID} tomcat
groupmod -g ${GroupID} tomcat

if [ "$DISABLE_DEFAULT_DEPLOY" != "true" ]; then
    rm -rf /node/webapps/*
    rm -rf /node/work/*
    rm -rf /node/temp/*
    rm -rf /node/logs

    mkdir /node/webapps/ROOT
    unzip /deploy/*.war -d /node/webapps/ROOT/

    mkdir -p /data/logs/$(cat /etc/hostname)
    chmod 0777 /data/logs/$(cat /etc/hostname)
    
    #tomcat Logs
    mkdir -p /data/logs/tomcat
    chmod 0777 /data/logs/tomcat
    ln -s /data/logs/tomcat /node/logs
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

if [ ! -d /node/conf ] && [ -d /node/conftemplate ]; then
    cp -nrp /node/conftemplate/. /tconf
fi

if [ "$CLUSTER" == "true" ]; then
    cp -f /tconf/server.cluster.xml /tconf/server.xml
fi

if [ "$(ls /tlib | wc -l)" != "0" ]; then
    cp /tlib/* /node/lib -f
fi

if [ -d /tconf ]; then
    cp -rf /tconf/. /node/conf
fi

if [ -d /certs ]; then
    for cert in $(ls -1 /certs);
    do
        certfile="/certs/$cert"
        alias="${certfile##*/}"
        alias="${filename%.*}"
        echo "Import $certfile with alias $alias"
        keytool -import -file "$certfile" -alias "$alias" -keystore "$JAVA_HOME/jre/lib/security/cacerts" -storepass changeit
    done
fi

chmod o+rx ${CATALINA_HOME} -R
chown ${UserID}:${GroupID} /data /deploy /conf /tconf /tlib $CATALINA_HOME $CATALINA_BASE -R

su tomcat -c $1
