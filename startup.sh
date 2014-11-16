#!/bin/sh

mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
echo "$1" > $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

/bin/bash
