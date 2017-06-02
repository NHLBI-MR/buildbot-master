#!/bin/bash

apt-get update
apt-get -y install python-pip
pip install --upgrade pip
pip install 'buildbot[bundle]'

buildbot create-master /home/buildbot/master
cp /home/buildbot/master/master.cfg.sample /home/buildbot/master/master.cfg

chown -R buildbot:buildbot /home/buildbot/master

cp buildbot-master.service /etc/systemd/system/
service buildbot-master start