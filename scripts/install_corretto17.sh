#!/bin/bash

function RunChecks {
    if [ "`id -u`" != "0" ]; then
        echo "You are not root! Abort."
        exit
    fi
}

function DownloadAndPrepare {
    wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz -P /usr/share -O /usr/share/corretto17.tar.gz
    mkdir /usr/share/corretto17
}

function Install {
    tar -C /usr/share/corretto17 -xvzf /usr/share/corretto17.tar.gz
    mv /usr/share/corretto17/amazon-corretto-17.0.2.8.1-linux-x64/* /usr/share/corretto17/
}

function RunLastStep {
    rm -r /usr/share/corretto17/amazon-corretto-17.0.2.8.1-linux-x64/
    update-alternatives --install /usr/bin/java java /usr/share/corretto17/bin/java 6
}

RunChecks
DownloadAndPrepare
Install
RunLastStep
