#!/bin/bash

#
# Infinitife ping loop
#

if [ -z $1 ] 
then
    domain=google.ru
else 
    domain=$1
fi


i=0
while true
do
    printf "%d\n" $i
    i=$((i + 1))
    ping $domain
done
