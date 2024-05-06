#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  bluetoothctl power on
else
  bluetoothctl disconnect
  bluetoothctl power off
fi
