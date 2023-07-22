#!/bin/zsh

# create encrypted store
printf '%s' $1 | hdiutil create -encryption AES-128 -stdinpass -size 1g -fs APFS -volname transfer $HOME/transfer.dmg

# mount disk
printf '%s' $1 | hdiutil attach -stdinpass $HOME/transfer.dmg

# unmount
hdiutil unmount /dev/disk5s1 
