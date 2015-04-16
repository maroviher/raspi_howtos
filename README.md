* autologin
    cp /usr/lib/systemd/system/getty@.service /usr/lib/systemd/system/autologin@.service
    edit /usr/lib/systemd/system/autologin@.service
      add -a root in  ExecStart=-/sbin/agetty --noclear -a root
    systemctl disable getty@tty1
    systemctl enable autologin@tty1
    systemctl enable autologin@tty2
    systemctl enable autologin@tty3
    ...

* Power consumption Watt
  
  +++++++++++++++++++++++
  Karte |idle|send
  ------|----|---
  ap2770|1,9 |2,3
  ap3070|3,6 |5
  ap5370|0,7 |1,4
  
  +++++++++++++++++++++++
     PI   |idle|100%CPU
  --------|----|-------
  B256/512|2,2 |2,5
  B+512   |1,45|1,65
  Tested with Apple power supply 2A with HDMI + Keyboard

  
  
* Resize partition in the disk image file
  http://softwarebakery.com/shrinking-images-on-linux

* Camera
  
  UDP:
  1. server: ./raspivid -n -t 0 -fps 25 -o -  -w 1296 -h 730 --bitrate 19000000 --profile high | nc -u -l -p 9999
  2. client: echo sdf | nc -u 192.168.49.128 9999 | mplayer -fps 200 -demuxer h264es -

  TCP:
  1. server: ./raspivid -n -t 0 -fps 25 -o -  -w 1296 -h 730 --bitrate 19000000 --profile high | nc -l -p 9999
  2. client: nc 192.168.49.128 9999 | mplayer -fps 200 -demuxer h264es -

  --intra 0 - produce only first keyframe(even on UDP with packet loss it seem to be OK, the bitrate is almost constant)
