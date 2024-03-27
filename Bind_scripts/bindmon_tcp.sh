# Monitor concurrent Bind TCP connections
# Requires Bind9 installed
# Requires mailx (RHEL) or mailutils (Debian) package


rndc_real=$(which rndc) 
ip_addr=$(hostname -I | awk '{print $1}')
status_output=$($rndc_real status 2>/dev/null)


if [ $? -eq 0 ];then   #Check if status_output exited without any errors


current=$(echo "$status_output" | awk '/tcp clients/ {print $3}' | cut -d / -f1)
max=$(echo "$status_output" | awk -F "/" '/tcp clients/ {print $2}')
treshold=$(expr "$max" \* 75 / 100)
treshold2=$(expr "$max" \* 90 / 100)

   if [[ "$current" -ge "$treshold" ]];then
     if [[ "$current" -ge "$treshold2" ]];then
     echo -e "CRITICAL level of DNS TCP connections on server: $ip_addr" | mail -s "CRITICAL Bind" "admin@someexample.com"
     else
     echo -e "WARNING! Max TCP connections almost reached for DNS server: $ip_addr" | mail -s "WARNING Bind" "admin@someexample.com"
     fi
   fi

else
	echo -e "$(date) Seems like DNS is not running on server: $ip_addr :: exit code: $?" &>> /var/log/bind_monitor.log   # Rndc didn't execute, most likely DNS is not running

fi
