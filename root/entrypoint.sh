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

PRODMAJOR=$(grep productVersion /node/webapps/ROOT/META-INF/MANIFEST.MF | cut -d " " -f2 | cut -d "." -f1,2 | cut -d "-" -f1)
echo "ky2help Major Version: $PRODMAJOR"

# prepare conftemplate from env flags
if [ -d /node/conftemplate ]; then
    if [ "$SECURE_COOKIE" == "true" ]; then
        cp -f /node/conftemplate/webhttps.xml /node/conftemplate/web.xml
    else
        cp -f /node/conftemplate/webhttp.xml /node/conftemplate/web.xml
    fi
    if [ "$CLUSTER" == "true" ]; then
        cp -f /node/conftemplate/server.cluster.xml /node/conftemplate/server.xml
    else
        cp -f /node/conftemplate/server.nocluster.xml /node/conftemplate/server.xml
    fi
fi

# rm old config folder if it exists from previous run
if [ -d /node/conf]; then
    rm -rf /node/conf
fi

# copy conftemplate to conf for base configs
if [ -d /node/conftemplate ]; then
    cp -rf /node/conftemplate /node/conf
fi

# copy mounted configs over existing
if [ -d /tconf ]; then
    cp -rf /tconf/. /node/conf
fi


if [ "$(ls /tlib | wc -l)" != "0" ]; then
    cp /tlib/* /node/lib -f
fi



if [ -d /certs ]; then
    for cert in $(ls -1 /certs);
    do
        certfile="/certs/$cert"
        alias="${certfile##*/}"
        alias="${alias%.*}"
        echo "Import $certfile with alias $alias"
        keytool -import -file "$certfile" -alias "$alias" -keystore "$JAVA_HOME/jre/lib/security/cacerts" -storepass changeit -noprompt
    done
fi

chmod o+rx ${CATALINA_HOME} -R
chown ${UserID}:${GroupID} /data /deploy /conf /tconf /tlib $CATALINA_HOME $CATALINA_BASE -R

su tomcat -c $1
