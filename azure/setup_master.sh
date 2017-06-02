#!/bin/bash

apt-get update
apt-get -y install python-pip
pip install --upgrade pip
pip install 'buildbot[bundle]'

buildbot create-master /home/buildbot/master
cp /home/buildbot/master/master.cfg.example /home/buildbot/master/master.cfg

cp buildbot-master.service /etc/systemd/system/
service buildbot-master start