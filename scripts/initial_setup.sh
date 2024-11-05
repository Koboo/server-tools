#!/bin/bash

### Variables ###
TMP="/tmp"
BASHRC="https://raw.githubusercontent.com/Koboo/server-tools/main/files/.bashrc"
SSH_KEYS="https://raw.githubusercontent.com/Koboo/server-tools/main/files/authorized_keys"
VIRTUAL_HOST=false

### Functions ###
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

function Update {
    apt-get update
    apt-get dist-upgrade -y
}

function InstallPackages {
    apt-get install htop iftop parted tree curl screen neofetch net-tools byobu xinetd nload nano tcpdump sudo psmisc -y
}

function SetupNeofetch {
    if ! grep --quiet neofetch /etc/profile; then
        echo neofetch >> /etc/profile
    fi
}

function SetupBashrc {
    wget_output=$(wget $BASHRC -O "${TMP}/bashrc")
    if [ ! $? -ne 0 ]; then
        rm /root/.bashrc
        rm /root/.bash_profile
        mv ${TMP}/bashrc /root/.bashrc
    fi
}

function SetupSsh {
    mkdir /root/.ssh/
    wget_output=$(wget $SSH_KEYS -O "${TMP}/authorized_keys")
    if [ ! $? -ne 0 ]; then
        mv ${TMP}/authorized_keys /root/.ssh/authorized_keys
    fi
    sed -i "/^[#?]*PasswordAuthentication[[:space:]]/c\PasswordAuthentication no" /etc/ssh/sshd_config
    systemctl restart ssh
}

function SetupFsTrim {
    if "$VIRTUAL_HOST" ; then
        rm /etc/cron.weekly/trim
        echo "#!/bin/bash" >> /etc/cron.weekly/trim
        echo "/sbin/fstrim --all || true" >> /etc/cron.weekly/trim
        chmod +x /etc/cron.weekly/trim
    fi
}


function CleanUp {
    rm /etc/motd -f
    rm /etc/update-motd.d/* -R -f
    apt-get autoremove -y
}

### Main ###
RunChecks
Update
InstallPackages
SetupNeofetch
SetupBashrc
SetupSsh
SetupFsTrim
CleanUp

echo "Finished initial setup!"
