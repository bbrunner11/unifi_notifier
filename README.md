# unifi_notifier

bash 4.x +

dependency on jq  https://stedolan.github.io/jq/

My first crack at Bash 4x AND the undocumented Unifi controller API


read the comments in the code

run with: nohup bash unifi_whoshome.sh $ for now, I'm working on something better

TRIGGER_TIME should likely be left alone.  The Unifi Controller reports with questionalble precision.... don't go below 30 seconds

disable DEBUG=true if you don't want nohup.out filling up, though logging is pretty minimal
