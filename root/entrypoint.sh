#!/bin/bash

usermod -u ${UserID} tomcat
groupmod -g ${GroupID} tomcat

if [ "$DISABLE_DEFAULT_DEPLOY" != "true" ]; then
    rm -rf /node/webapps/*
    rm -rf /node/work/*
    rm -rf /node/temp/*
    rm -rf /node/logs
    rm -rf /data/logs/*

    mkdir /node/webapps/ROOT
    unzip /deploy/*.war -d /node/webapps/ROOT/

    mkdir /data/logs/$(cat /etc/hostname)
    chmod 0777 /data/logs/$(cat /etc/hostname)
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
    cp -nrp /node/conftemplate/* /tconf
fi

if [ "$CLUSTER" == "true" ]; then
    cp -f /tconf/server.cluster.xml /tconf/server.xml
fi

if [ "$(ls /tlib | wc -l)" != "0" ]; then
    cp /tlib/* /node/lib -f
fi

if [ -d /tconf ]; then
    cp -rf /tconf /node/conf
fi

chmod o+rx ${CATALINA_HOME} -R
chown ${UserID}:${GroupID} /data /deploy /conf /tconf /tlib $CATALINA_HOME $CATALINA_BASE -R

su tomcat -c $1
