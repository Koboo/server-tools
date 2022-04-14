#!/bin/bash
function RunChecks {
    if [ "`id -u`" != "0" ]; then
        echo "You are not root! Abort."
        exit
    fi
}

function RemoveOldKernels {
    sudo apt-get purge $( sudo dpkg --list | sudo egrep 'linux-image-[0-9]' | sudo awk '{print $3,$2}' | sudo sort -nr | sudo tail -n +2 | sudo grep -v $(uname -r) | sudo awk '{ print $2}')
    echo "Removed old kernels.."
}

function CleanUp {
    sudo aptitude search ~c
    sudo aptitude purge ~c
    sudo apt-get autoremove
    sudo apt-get autoclean
    sudo apt-get clean
    echo "Finished cleanup.."
}


RunChecks
RemoveOldKernels
CleanUp
