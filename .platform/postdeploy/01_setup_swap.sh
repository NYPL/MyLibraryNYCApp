#!/bin/bash

/bin/dd if=/dev/zero of=/var/swapfile bs=1M count=2048
/bin/chmod 600 /var/swapfile
/sbin/mkswap /var/swapfile
/sbin/swapon /var/swapfile