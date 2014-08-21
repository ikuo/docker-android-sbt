#!/bin/sh

echo Welcome!
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
echo "$1" > $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys
sudo /etc/init.d/ssh start

/bin/bash
