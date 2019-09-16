#!/bin/bash

if [ "$ADDITIONAL_SCRIPT" != "" ]; then
    source $ADDITIONAL_SCRIPT
fi

# for backward compatibility
if [ -e /node/init.sh ]; then
    source /node/init.sh
fi

export CATALINA_OPTS="$CATALINA_OPTS"
exec ${CATALINA_HOME}/bin/catalina.sh run
