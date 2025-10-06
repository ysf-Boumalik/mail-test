#!/bin/bash

echo "Running prerun.sh"
cd mails
chmod +x *
sudo su -c "./postfix.sh && ./send.sh --allow-root"