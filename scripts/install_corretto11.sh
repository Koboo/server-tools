#!/bin/bash

function RunChecks {
    if [ "`id -u`" != "0" ]; then
        echo "You are not root! Abort."
        exit
    fi
}

function DownloadAndPrepare {
    wget https://corretto.aws/downloads/latest/amazon-corretto-11-x86-linux-jdk.tar.gz -P /usr/share -O /usr/share/corretto11.tar.gz
    mkdir /usr/share/corretto11
}

function Install {
    tar -C /usr/share/corretto11 -xvzf /usr/share/corretto11.tar.gz
    mv /usr/share/corretto11/amazon-corretto-11.0.14.10.1-linux-x86/* /usr/share/corretto11/
}

function RunLastStep {
    rm -r /usr/share/corretto11/amazon-corretto-11.0.14.10.1-linux-x86/
    rm -r /usr/share/corretto11.tar.gz
    update-alternatives --install /usr/bin/java java /usr/share/corretto11/bin/java 6
}

RunChecks
DownloadAndPrepare
Install
RunLastStep
