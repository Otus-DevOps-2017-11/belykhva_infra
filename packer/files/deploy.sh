#!/bin/bash
git clone https://github.com/Otus-DevOps-2017-11/reddit.git ~/reddit
cd ~/reddit && bundle install
mv /tmp/app.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable app.service
systemctl start app.service
