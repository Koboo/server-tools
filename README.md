# // _Server Tools and Scripts_

## Links
* [Git Paper](docu/USEFUL_FOR_GIT.md)
* [Install Dropbox](docu/INSTALL_DROPBOX.md)
* [Gradle Paper](docu/GRADLE.md)
* [JDK17 Paper](docu/JDK17.md)
* [Jarfix](docu/JAR_FIX.md)
* [Bash Snippets](https://github.com/alexanderepstein/Bash-Snippets)
* [Change Hostname](docu/CHANGE_HOSTNAME.md)

## Files
* [EditorConfig](.editorconfig)

## Setup Debian 10/11 machines

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/initial_setup.sh)"`

#### Future goals / ToDo
* [Timezone setting](https://linuxize.com/post/how-to-set-or-change-timezone-on-debian-10/)
* Make Java and Cleanup Global commands through Initial setup

## Cleanup Debian 10/11 machines

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/clean_up.sh)"`

## Benchmark Debian 10/11 machines

`wget -qO- bench.sh | bash`

## Java Installation

#### Script

`wget - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh`

Available JDK Versions:

* (5) ``GraalVM 11``
* (4) ``GraalVM 17``
* (3) ``Corretto 17``
* (2) ``OpenJDK 17``
* (1) ``OpenJDK 11``
