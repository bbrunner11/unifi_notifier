
#!/bin/bash

DEBUG=true
TRIGGER_TIME=45  #time difference between status changes in seconds to trigger a notification
SLEEP_TIME=60 #seconds to sleep before checking status of device again
PUSHOVER_DEVICE_TOKEN="your_device_token"
PUSHOVER_USER_TOKEN="your_user_token"
UNIFI_UN="your_unifi_login"
UNIFI_PW="your_unifi_password"
UNIFI_ADDRESS="your_unifi_address"

declare -A last_seen_macs=( ) mac_to_user=( ) mac_to_status=( )
mac_to_user=( ["c8:08:e9:cc:0d:2c"]="device1" ["d0:c5:f3:66:5c:a8"]="device2" ["58:40:4e:18:a5:88"]="device3" ["88:6b:6e:65:b0:bc"]="device4" )

send_notification() {
echo "Sent Pushover notification: $1"
curl -sS -F "token=$PUSHOVER_DEVICE_TOKEN" -F "user=$PUSHOVER_USER_TOKEN" -F "title=Device Status Change" -F "message=$1" https://api.pushover.net/1/messages.json > /dev/null 2>&1
}

while : #loop forever
do
DATE_NOW=`date` #human readable date used for logging
NOW=`date +%s` #this is the current epoch timestamp since Unifi also computes epoch timestamps for activity
curl -sS "https://${UNIFI_ADDRESS}/api/login" --data-binary "{\"username\":\"${UNIFI_UN}\",\"password\":\"${UNIFI_PW}\",\"strict\":true}" --compressed --insecure -c cookies.txt > /dev/null 2>&1

#TODO: Use the next request to compare to known MACs for intrusion detection???
#RESP=`curl --insecure -b cookies.txt -c cookies.txt 'https://${UNIFI_ADDRESS}/api/s/default/stat/alluser'`

for mac in "${!mac_to_user[@]}"; do #loop over array (predefined macs as keys)

    RESP=`curl -sS --insecure -b cookies.txt -c cookies.txt "https://${UNIFI_ADDRESS}/api/s/default/stat/user/${mac}"`
	while IFS= read -r last_seen_mac && 
      		IFS= read -r ts; do

  		last_seen_macs[$last_seen_mac]=$ts #store the time the device was last seen for debug purposes, not used in main script
		diff=$(($NOW-$ts))

		if(($diff < $TRIGGER_TIME)); then 
			flag=1
		else
			flag=0
		fi
	if ((${#mac_to_status[@]} == ${#mac_to_user[@]})); then #fake counter -- if array is empty, this is first run so skip, otherwise do work
		if ((mac_to_status[$mac] > $flag)); then
			send_notification " ${mac_to_user[$mac]} device went DOWN"
		elif ((mac_to_status[$mac] < $flag)); then
			send_notification " ${mac_to_user[$mac]} device went UP"
		else 
			echo "" > /dev/null
		fi  
	fi

	mac_to_status[$mac]=$flag

		if($DEBUG); then
  			echo "$DATE_NOW -- Mac is $last_seen_mac (${mac_to_user[$mac]}) at $ts which was $((($NOW-$ts)/60)) mins ago"
		fi
	done < <(jq -r '.data[] | (.mac, .last_seen)' <<<$RESP);
done
sleep $SLEEP_TIME
done
