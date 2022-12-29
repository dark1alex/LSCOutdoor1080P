#!/bin/sh
cd /tmp/sd/onvif/

STEPS=15
MOTOR_CONTROL="/tmp/sd/onvif/motor.sh"

LEFT="$MOTOR_CONTROL $STEPS left "
RIGHT="$MOTOR_CONTROL $STEPS right"
UP="$MOTOR_CONTROL $STEPS up"
DOWN="$MOTOR_CONTROL $STEPS down"


IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
while [[ -z $IP_ADDR ]]; do
    IP_ADDR=$(ip -4 addr show wlan0 | grep inet | awk '{print $2}' | cut -d'/' -f1)
done
echo $IP_ADDR

ONVIF_PROFILE_0="--name HD --width 1920 --height 1080 --url rtsp://$IP_ADDR:554/main_ch --type H264"
#ONVIF_PROFILE_1="--name SD --width 640 --height 360 --url rtsp://$IP_ADDR:554/sub_ch --type H264"
ONVIF_PROFILE_1=""
echo $ONVIF_PROFILE_0
echo $ONVIF_PROFILE_1

exec ./onvif_srvd --no_fork --pid_file /var/run/onvif_srvd.pid --model "Rotable Camera" --manufacturer "LSC" --ifs wlan0 --port 5000 --scope onvif://www.onvif.org/Profile/S $ONVIF_PROFILE_0 $ONVIF_PROFILE_1 \
        --ptz \
        --move_left "eval $LEFT" \
        --move_right "eval $RIGHT" \
        --move_up "eval $UP" \
        --move_down "eval $DOWN"