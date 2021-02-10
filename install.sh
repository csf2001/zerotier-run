#!/bin/sh

sudo cp zerotier-run.sh /usr/bin/
sudo cp zerotier-cli.service /usr/lib/systemd/system/
sudo systemctl enable zerotier-cli.service
sudo systemctl daemon-reload
sudo systemctl start zerotier-cli.service
echo "Install Complete!"
echo "Import: You need modify the head of script use your network information through run: sudo vi /usr/bin/zerotier-run.sh"