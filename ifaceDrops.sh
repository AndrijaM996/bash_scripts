#!/bin/bash

# Very simple script for calculating dropped TX and RX packets on every interface

Iface=$(ifconfig -a | grep 'DOWN\|UP' | awk '{print $1}' | tr -d : )


for iface in $Iface;do

	RXPacket=$(ifconfig $iface | egrep 'RX.*packet' | awk '{print $3}')
	TXPacket=$(ifconfig $iface | egrep 'TX.*packet' | awk '{print $3}')

	RXDrop=$(ifconfig $iface | egrep 'RX.*drop' | awk '{print $5}')
	TXDrop=$(ifconfig $iface | egrep 'TX.*drop' | awk '{print $5}')

	echo -e "Interface = $iface"
	
	if [ $RXPacket -eq 0 ];then
		echo -e "\tRX Drops = No packets received"
	elif [ $RXDrop -eq 0 ];then
		echo -e "\tRX Drops = No dropped packets"
	else
		RXPercent=$(echo -e "scale=3; ($RXPacket / $RXDrop) * 100" | bc -l)
		echo -e "\tRX Drops = $RXPercent%"
	fi


	if [ $TXPacket -eq 0 ];then
		echo -e "\tTX Drops = No packets received"
	elif [ $TXDrop -eq 0 ];then
		echo -e "\tTX Drops = No dropped packets"
	else
		TXPercent=$(echo -e "scale=3; ($TXPacket / $TXDrop) * 100" | bc -l)
		echo -e "\tTX drops = $TXDrop\n"
	fi

done 

