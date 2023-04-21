#!/bin/bash

wlanConnected=$(nmcli dev status | grep -vE "ethernet|loopback|wifi-p2p" | grep wifi | grep -w 'conectado\|connected')
existWifi=$(echo $wlanConnected | wc -c )


if [ $existWifi -ge 7  ]; then

    wlanIface=$(echo $wlanConnected | awk '{print $1}')
    wlanIp=$(ifconfig $wlanIface| head -n 2 | tail -n 1 | awk '{print $2}'  )

   echo -e "%{F#FFFF} \ufaa8 $wlanIp %{u-}"
else 
    ethConnected=$(nmcli dev status | grep -vE "wifi|loopback|wifi-p2p" | grep ethernet | grep -w 'conectado\|connected')
    existEth=$(echo $ethConnected | wc -c )
    if [ $existEth -ge 7  ]; then
        ethIface=$(echo $ethConnected | awk '{print $1}')
        ethIp=$(ifconfig $ethIface| head -n 2 | tail -n 1 | awk '{print $2}'  )
        echo -e "%{F#FFFF} \uf6ff $ethIp %{u-}"
    else
        echo "%{F#FF0000}$( echo -e "\uf6a6 No networks" )%{u-}"
    fi
fi