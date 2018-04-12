#!/bin/bash
docker build -t simplehttp simplehttp/
docker build -t centos-base centos-base/
docker build -t systemd-base centos-desktop/systemd-base/
docker build -t ephemeral-desktop centos-desktop/ephemeral-desktop/
docker build -t persistent-desktop centos-desktop/persistent-desktop/
