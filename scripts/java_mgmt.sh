#!/bin/bash

###############################################################
#
# Java Version Management Bash Script 1.3 by Koboo
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

    if [ -d "/usr/share/$3/" ]; then
        echo "'/usr/share/$3/' is already installed! Automatic uninstallation.."
        uninstallJava $3
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

    if ! [ -d "/usr/share/$1/" ]; then
        echo "'/usr/share/$1/' doesn't exists!"
    fi
    
    if ! [ -z $(update-alternatives --list java | grep "$1") ]; then
        update-alternatives --remove java /usr/share/graal17/bin/java
        echo "$1 was used in update-alternatives. Removing could result in errors."
    fi
    
    if ! [ -z $(echo $JAVA_HOME | grep "$1") ]; then
        unset JAVA_HOME
        echo "$1 was used in \$JAVA_HOME. Removing could result in errors."
    fi
    
    if [[ ! -z $(cat "/etc/profile.d/export_java_home.sh" | grep "graal11") ]]; then
        rm -r /etc/profile.d/export_java_home.sh
        echo "$1 was used in '/etc/profile.d/export_java_home.sh'. Removing could result in errors."
    fi
    
    echo "Removing directory /usr/share/$1"
    rm -r /usr/share/$1
    
    echo "Successful uninstalled /usr/share/$1!"
    echo "To avoid errors, run the '-u' command, to update \$JAVA_HOME, update-alternatives and '/etc/profile.d/export_java_home.sh'! "
}


# $1 = directory-name to deploy
function checkExecution {
    echo ""
    if [ -z "$JAVA_HOME" ]; then
        echo "Current JAVA_HOME is empty!"
    else
        echo "Current JAVA_HOME is '$JAVA_HOME'"
    fi
    
    echo "Setting JAVA_HOME to '/usr/share/$1'.."
    writeJavaHome /etc/profile.d/export_java_home.sh /usr/share/$1


    echo "Setting update-alternatives to '/usr/share/$1'.."
    writeAlternatives /usr/share/$1
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
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> $1
    chmod 777 $1
    echo "Finished creating new script in $1!"
}

# $1 = java home path
function writeAlternatives {
    echo ""
    javaPrograms=("java" "javac")
    update-alternatives --remove-all java
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
    echo "Currently these versions are supported:"

    echo ""
    printVersion graal11 GraalVMv11 1
    printVersion graal17 GraalVMv17 2
    printVersion corretto17 Correttov17 3
    printVersion openjdk17 OpenJDKv17 4
    printVersion openjdk11 OpenJDKv11 5
    echo ""
}

# $1 = directory name of version
# $2 = Beautified Name
# $3 = Index
function printVersion {
    if [ -d "/usr/share/$1" ]; then
        echo "    - ($3) $2 (Installed: /usr/share/$1)"
    else 
        echo "    - ($3) $2 (Not installed)"
    fi
}

function showHelp {
    echo ""
    echo "Please select one of these options:"
    echo ""
    echo "    -s (Show all java versions and installation status)"
    echo "    -h (Show this help message)"
    echo "    -i [index] (Install a selected java version)"
    echo "    -r [index] (Install a selected java version)"
    echo "    -u [index] (Install a selected java version)"
    echo ""
    showVersions
}

# Check if we got enough privileges for the execution of the script
if [ "`id -u`" != "0" ]; then
    echo "We are not root! Abort. We do not have enough privilges.. :("
    exit
fi


# $1 = option-argument (e.g. '-i')
# $2 = version-index (e.g. '1' = GraalVMv11)

if [ -z "$1" ]; then
    showHelp
    exit
fi

if [ $1 = "-h" ]; then
    showHelp
    exit
fi

if [ $1 = "-s" ]; then
    showVersions
    exit
fi

if [ -z "$2" ]; then
    showHelp
    exit
fi

if [ $1 = "-i" ]; then
    if [ $2 = "1" ]; then
        dstDir=graal11
        downloadJava https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.0.0.2/graalvm-ce-java11-linux-amd64-22.0.0.2.tar.gz graalvm-ce-java11-22.0.0.2 $dstDir
        checkExecution $dstDir
        echo "Finished installation of GraalVM v11! Please re-login, so that changes take effect!"
        exit
    elif [ $2 = "2" ]; then
        dstDir=graal17
        downloadJava https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.0.0.2/graalvm-ce-java17-linux-amd64-22.0.0.2.tar.gz graalvm-ce-java17-22.0.0.2 $dstDir
        checkExecution $dstDir
        echo "Finished installation of GraalVM v17! Please re-login, so that changes take effect!"
        exit
    elif [ $2 = "3" ]; then
        dstDir=corretto17
        downloadJava https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz amazon-corretto-17.0.2.8.1-linux-x64 $dstDir
        checkExecution $dstDir
        echo "Finished installation of Corretto v17! Please re-login, so that changes take effect!"
        exit
    elif [ $2 = "4" ]; then
        dstDir=openjdk17
        downloadJava https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz jdk-17.0.2 $dstDir
        checkExecution $dstDir
        echo "Finished installation of OpenJDK v17! Please re-login, so that changes take effect!"
        exit
    elif [ $2 = "5" ]; then
        dstDir=openjdk11
        downloadJava https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz jdk-11.0.2 $dstDir
        checkExecution $dstDir
        echo "Finished installation of OpenJDK v11! Please re-login, so that changes take effect!"
        exit
    else
        echo "$2 is not a valid java version. Abort."
        showHelp
        exit
    fi
elif [ $1 = "-r" ]; then
    if [ $2 = "1" ]; then
        uninstallJava graal11
        exit
    elif [ $2 = "2" ]; then
        uninstallJava graal17
        exit
    elif [ $2 = "3" ]; then
        uninstallJava corretto17
        exit
    elif [ $2 = "4" ]; then
        uninstallJava openjdk17
        exit
    elif [ $2 = "5" ]; then
        uninstallJava openjdk11
        exit
    else
        echo "$2 is not a valid java version. Abort."
        showHelp
        exit
    fi
elif [ $1 = "-u" ]; then
    if [ $2 = "1" ]; then
        checkExecution graal11
        exit
    elif [ $2 = "2" ]; then
        checkExecution graal17
        exit
    elif [ $2 = "3" ]; then
        checkExecution corretto17
        exit
    elif [ $2 = "4" ]; then
        checkExecution openjdk17
        exit
    elif [ $2 = "5" ]; then
        checkExecution openjdk11
        exit
    else
        echo "$2 is not a valid java version. Abort."
        showHelp
        exit
    fi
fi


