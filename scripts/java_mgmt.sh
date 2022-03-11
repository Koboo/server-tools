#!/bin/bash

###############################################################
#
# Java Version Management Bash Script 1.2 by Koboo
#
# This script is made to simplify and manage Java installations. 
# If you encounter any bugs or unwanted behavior, 
# please open an issue on:
#
# https://github.com/Koboo/server-tools
#
# Contributions and further improvements are always welcome!
#
# Have fun! :)
#
# Legal notice:
# The creator of the script is not liable for any kind of damage 
# to hardware or software.
#
# Unless you know what you are doing, you should not make any changes.
#
###############################################################

# $1 = download-link
# $2 = directory-name in tar-file
# $3 = directory-name to install
function downloadJava {
    echo ""
    echo "Starting installation of $3.."

    if [ "`id -u`" != "0" ]; then
        echo "We are not root! Abort. We do not have enough privilges.. :("
        exit
    fi
    echo "We are root, that's great! We can proceed the process.."

    if [ -d "/usr/share/$3/" ]; then
        echo "'/usr/share/$3/' is already installed! Please uninstall it first."
        read -p "Do you want to uninstall /usr/share/$3? (y/n) " optionUninstall
        if [ $optionUninstall = "y" ]; then
            uninstallJava $3
        else
            echo "Aborting.."
        exit
        fi
    fi

    if [ -f "/usr/share/install_java_$3.tar.gz" ]; then
        echo "Tar file '/usr/share/install_java_$3.tar.gz' already exists! Abort."
    else 
        echo "Start download of $1.."
        echo "This will take a few minutes.. Please wait.."
        wget -q $1 -P /usr/share -O /usr/share/install_java_$3.tar.gz
        echo "Successful downloaded $1!"
    fi

    echo "Creating directory /usr/share/$3"
    mkdir /usr/share/$3
    tar -C /usr/share/$3 -xzf /usr/share/install_java_$3.tar.gz
    
    mv /usr/share/$3/$2/* /usr/share/$3/
    
    rm -r /usr/share/$3/$2/
    rm -r /usr/share/install_java_$3.tar.gz
    
    echo "Finished installation of $3! "
}


# $1 = directory-name of installation
function uninstallJava {
    echo ""
    echo "Starting uninstallation of $1.."

    if [ "`id -u`" != "0" ]; then
        echo "We are not root! Abort. We do not have enough privilges.. :("
        exit
    fi
    echo "We are root, that's great! We can proceed the process.."

    if ! [ -d "/usr/share/$1/" ]; then
        echo "'/usr/share/$1/' is not installed! Abort."
        exit
    fi

    echo "Removing directory /usr/share/$1"
    rm -r /usr/share/$1
    
    if ! [ -z $(update-alternatives --list java | grep "$1") ]; then
        read -p "$1 is used in update-alternatives. Do you want to clear it? (y/n) " remUpAlt
        if [ $remUpAlt = "y" ]; then
            update-alternatives --remove java /usr/share/graal17/bin/java
            echo "Maybe you want to set another installation as update-alternative. Please execute the script again to do that."
        fi
    fi
    
    if ! [ -z $(echo $JAVA_HOME | grep "$1") ]; then
        read -p "$1 is used in JAVA_HOME. Do you want to clear it? (y/n) " remEnvVar
        if [ $remEnvVar = "y" ]; then
            unset JAVA_HOME
            echo "Maybe you want to set another installation as JAVA_HOME. Please execute the script again to do that."
        fi
    fi
    
    echo "Successful uninstalled /usr/share/$1!"
}


# $1 = directory-name to deploy
function checkExecution {
    echo ""
    if [ -z "$JAVA_HOME" ]; then
        echo "Current JAVA_HOME is empty!"
    else
        echo "Current JAVA_HOME is '$JAVA_HOME'"
    fi
    read -p "Do you want to change JAVA_HOME to '/usr/share/$1'? (y/n) " setEnvVar

    if [ $setEnvVar = "y" ]; then
        echo "Setting JAVA_HOME to '/usr/share/$1'.."
        writeJavaHome /etc/profile.d/export_java_home.sh /usr/share/$1
    fi

    read -p "Do you want to set update-alternatives? (y/n) " setUpAlt
    if [ $setUpAlt = "y" ]; then
        echo "Setting update-alternatives to '/usr/share/$1'.."
        writeAlternatives /usr/share/$1
    fi
}

# $1 = path and name of script
# $2 = java home path
function writeJavaHome {
    echo ""
    if [ -f "$1" ]; then
        rm $1
    fi
    touch $1
    echo "#!/bin/bash" >> $1
    echo "export JAVA_HOME=$2" >> $1
    echo "export PATH=$JAVA_HOME/bin:$PATH" >> $1
    chmod 777 $1
    echo "Finished creating new script in $1!"
}

# $1 = java home path
function writeAlternatives {
    echo ""
    javaPrograms=("java" "javac")
    read -p "Do you want to clear update-alternatives? (y/n) " clearUpAlt
    if [ $clearUpAlt = "y" ]; then
        update-alternatives --remove-all java
    fi
    for program in ${javaPrograms[@]}; do
        if [ -f "$1/bin/$program" ]; then
            update-alternatives --install /usr/bin/$program $program $1/bin/$program 100
        else
            echo "File $1/bin/$program doesn't exists. Skipping.."
        fi
    done
    echo "Finished setting updates-alternatives of $1!"
}

function showVersions {
    echo "Currently there are the following version downloaded:"
    if [ -d "/usr/share/graal11" ]; then
        echo " - (1) GraalVM v11 (/usr/share/graal11)"
    fi
    if [ -d "/usr/share/graal17" ]; then
        echo " - (2) GraalVM v17 (/usr/share/graal17)"
    fi
    if [ -d "/usr/share/corretto17" ]; then
        echo " - (3) Corretto v17 (/usr/share/corretto17)"
    fi
    if [ -d "/usr/share/openjdk17" ]; then
        echo " - (4) OpenJDK v17 (/usr/share/openjdk17)"
    fi
    if [ -d "/usr/share/openjdk11" ]; then
        echo " - (5) OpenJDK v11 (/usr/share/openjdk11)"
    fi
}


echo "Which java should be installed?"
echo " - (1) Install GraalVM v11 (x64)"
echo " - (2) Install GraalVM v17 (x64)"
echo " - (3) Install Corretto v17 (x64)"
echo " - (4) Install OpenJDK v17 (x64)"
echo " - (5) Install OpenJDK v11 (x64)"
echo " - (01) Uninstall installed versions"
echo " - (02) Update installed versions"
read -p "Select a option from the list above: " javaVersion

if [ $javaVersion = "01" ]; then
    echo ""

    showVersions
    read -p "Select a version to uninstall from the list above: " javaDir
    
    if [ $javaDir = "1" ]; then
        uninstallJava graal11
    elif [ $javaDir = "2" ]; then
        uninstallJava graal17
    elif [ $javaDir = "3" ]; then
        uninstallJava corretto17
    elif [ $javaDir = "4" ]; then
        uninstallJava openjdk17
    elif [ $javaDir = "5" ]; then
        uninstallJava openjdk11
    else
        echo "$javaDir is not a valid version. Abort."
        exit
    fi
    
elif [ $javaVersion = "02" ]; then
    echo ""

    showVersions
    read -p "Select a version to update from the list above: " javaDir
    
    if [ $javaDir = "1" ]; then
        checkExecution graal11
    elif [ $javaDir = "2" ]; then
        checkExecution graal17
    elif [ $javaDir = "3" ]; then
        checkExecution corretto17
    elif [ $javaDir = "4" ]; then
        checkExecution openjdk17
    elif [ $javaDir = "5" ]; then
        checkExecution openjdk11
    else
        echo "$javaDir is not a valid version. Abort."
        exit
    fi
    
elif [ $javaVersion = "1" ]; then

    dstDir=graal11
    downloadJava https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.0.0.2/graalvm-ce-java11-linux-amd64-22.0.0.2.tar.gz graalvm-ce-java11-22.0.0.2 $dstDir
    checkExecution $dstDir

    echo "Finished installation of GraalVM v11! Please re-login, so that changes take effect!"
    
elif [ $javaVersion = "2" ]; then

    dstDir=graal17
    downloadJava https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.0.0.2/graalvm-ce-java17-linux-amd64-22.0.0.2.tar.gz graalvm-ce-java17-22.0.0.2 $dstDir
    checkExecution $dstDir

    echo "Finished installation of GraalVM v17! Please re-login, so that changes take effect!"
    
elif [ $javaVersion = "3" ]; then

    dstDir=corretto17
    downloadJava https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz amazon-corretto-17.0.2.8.1-linux-x64 $dstDir
    checkExecution $dstDir

    echo "Finished installation of Corretto v17! Please re-login, so that changes take effect!"
    
elif [ $javaVersion = "4" ]; then

    dstDir=openjdk17
    downloadJava https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz jdk-17.0.2 $dstDir
    checkExecution $dstDir

    echo "Finished installation of OpenJDK v17! Please re-login, so that changes take effect!"
    
elif [ $javaVersion = "5" ]; then

    dstDir=openjdk11
    downloadJava https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz jdk-11.0.2 $dstDir
    checkExecution $dstDir

    echo "Finished installation of OpenJDK v11! Please re-login, so that changes take effect!"
    
else
  echo "$javaVersion is not a valid option. Abort."
  exit
fi


