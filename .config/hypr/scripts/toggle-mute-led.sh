#!/usr/bin/env bash

DEV="/dev/snd/hwC2D0"
CMD_ON="sudo hda-verb $DEV 0x20 0x500 0x0b && sudo hda-verb $DEV 0x20 0x400 0x8"
CMD_OFF="sudo hda-verb $DEV 0x20 0x500 0x0b && sudo hda-verb $DEV 0x20 0x400 0x0"
# Проверка mute через wpctl (PipeWire)
if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep 'MUTED' > /dev/null; then
  # звук отключен, включаем LED 
  eval $CMD_OFF >> /tmp/toggle-mute-led-test.log
  
else
  eval $CMD_ON >> /tmp/toggle-mute-led-test.log
fi
