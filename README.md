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
  Karte |idle|send
  ------|----|---
  ap2770|1,9 |2,3
  ap3070|3,6 |5
  ap5370|0,7 |1,4
  
* Resize partition in the disk image file
  http://softwarebakery.com/shrinking-images-on-linux
