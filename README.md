# unifi_notifier

bash 4.x +


My first crack at Bash 4x AND the undocumented Unifi controller API


read the comments in the code

run with: nohup bash unifi_whoshome.sh $ for now, I'm working on something better
TRIGGER_TIME should likely be left alone.  The Unifi Controller reports with questionalble precision.... don't go below 30 seconds
disable DEBUG=true if you don't want nohup.out filling up, though it's pretty minimal and unless you're anal won't affect any sane user.  Working on a cron and/or log rotate if your MAC list is huge (though this would be impractical w/ this script).
