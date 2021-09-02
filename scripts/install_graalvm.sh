#!/bin/bash

VERSION=21.1.0
JAVA_VERSION=java8

function RunChecks {
    if [ "`id -u`" != "0" ]; then
        echo "You are not root! Abort."
        exit
    fi
}

function DownloadAndPrepare {
    wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$VERSION/graalvm-ce-$JAVA_VERSION-linux-amd64-$VERSION.tar.gz -P /usr/share -O /usr/share/graalvm.tar.gz
    mkdir /usr/share/graalvm
}

function InstallGraal {
    tar -C /usr/share/graalvm -xvzf /usr/share/graalvm.tar.gz
    mv /usr/share/graalvm/graalvm-ce-$JAVA_VERSION-$VERSION/* /usr/share/graalvm/
}

function RunLastStep {
    rm -r /usr/share/graalvm/graalvm-ce-$JAVA_VERSION-$VERSION/
    update-alternatives --install /usr/bin/java java /usr/share/graalvm/bin/java 6
}

RunChecks
DownloadAndPrepare
InstallGraal
RunLastStep
