#!/bin/bash
# Description: find and ping router/gateway
GATEWAY=$(ip route | grep "default via" | awk '{print $3}')
if [ $? != 0 ];
    then echo "No internet gateways found"; exit 1
    else ping $GATEWAY
fi


