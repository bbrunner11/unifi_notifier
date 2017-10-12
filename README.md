# unifi_notifier

My first crack at Bash 4x AND the undocumented Unifi controller API



dependency on jq  https://stedolan.github.io/jq/ and bash 4.x

notifications are sent via Pushover https://pushover.net 

to run unattended: nohup bash unifi_whoshome.sh $ 

TRIGGER_TIME should likely be left alone.  The Unifi Controller reports with questionalble precision.... don't go below 30 seconds

disable DEBUG=true if you don't want nohup.out filling up, though logging is pretty minimal
