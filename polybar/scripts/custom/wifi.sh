#!/bin/bash

connected=$(nmcli dev status | grep -vE "ethernet|loopback|wifi-p2p" | grep wifi | grep -w 'conectado\|connected')
exist=$(echo $connected | wc -c )


if [ $exist -ge 7 ]; then
    essid=$(echo $connected | awk '{print $4}') 
    echo " %{F#05ff26}$(echo -e "\ufaa8 $essid") %{u-}"
else
    echo "%{F#FF0000}$(echo -e "\ufaa8 No wifi" )%{u-}"
fi