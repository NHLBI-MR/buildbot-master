Buildbot Setup NHLBI
====================

This repository contains configuration files and deployment scripts needed to setup a [buildbot](https://buildbot.net) master. This includes automatic configuration of an Azure VM to host the master. 

Please note that the automatic configuration of the host requires access to the setup scripts and since this repository is hosted in a private github repository, the explicit references are made to a duplicate of the scripts and templates, which can be found in [https://github.com/hansenms/cloud/buildbot/master](https://github.com/hansenms/cloud/buildbot/master). 

After setting up the buildbot master, the generic `master.cfg` should be replace with the one in this repository and the master should be restarted. 


Setting up a worker
-------------------

A worker (formerly known as a build slave) can be set up easily in a python virtual environment.

First create a virtual environment:

```
sudo su - buildbot
mkdir ~/virtualenvs
virtualenv ~/virtualenvs/buildbot
source virtualenvs/buildbot/bin/activate
```

Then install buildbot:

```
pip install --upgrade pip
pip install 'buildbot[bundle]'
```

Create a worker:

```
mkdir buildbot_workers
cd buildbot_workers/
buildbot-worker create-worker docker-image-worker gtbuildbot.eastus.cloudapp.azure.com docker-image-worker gadgetron
```

Create init script to start on boot. For Upstart, this would look like:

```
description     "docker image buildbot slave"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

script
    cd /home/buildbot/buildbot_workers/docker-image-worker
    sudo -u buildbot /home/buildbot/virtualenvs/buildbot/bin/buildbot-worker start --nodaemon
end script
```

For systemd, it would look like:

```
[Unit]
Description=BuildBot worker service
After=network.target

[Service]
User=buildbot
Group=buildbot
WorkingDirectory=/home/buildbot/buildbot_workers/docker-image-worker
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
ExecStart=/home/buildbot/virtualenvs/buildbot/bin/buildbot-worker start --nodaemon

[Install]
WantedBy=multi-user.target
```

Then start the service. Watch for any errors in the log: `/home/buildbot/buildbot_workers/docker-image-worker/twistd.log`



