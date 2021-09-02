#!/bin/bash
function RunChecks {
    if [ "`id -u`" != "0" ]; then
        echo "You are not root! Abort."
        exit
    fi
    
    # Debian 9
    if lscpu | grep "Hypervisor vendor:     KVM"; then
        VIRTUAL_HOST=true
    fi
    
    # Debian 10
    if lscpu | grep "Hypervisor vendor:   KVM"; then
        VIRTUAL_HOST=true
    fi
}

function CleanUp {
    sudo aptitude search ~c
    sudo aptitude purge ~c
    sudo apt-get autoremove
    sudo apt-get autoclean
    echo "Finished cleanup.."
}


RunChecks
CleanUp
