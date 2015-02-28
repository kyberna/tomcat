#!/bin/bash
source /node/init.sh

export CATALINA_OPTS="$CATALINA_OPTS"
exec ${CATALINA_HOME}/bin/catalina.sh run
