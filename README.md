# // _Server Tools and Scripts_

## Links
* [Change Hostname](docu/CHANGE_HOSTNAME.md)
* [Useful for Git](docu/USEFUL_FOR_GIT.md)
* [Bash Snippets](https://github.com/alexanderepstein/Bash-Snippets)

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

`wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh`

Available JDK Versions:

* (5) ``GraalVM 11``
* (4) ``GraalVM 17``
* (3) ``Corretto 17``
* (2) ``OpenJDK 17``
* (1) ``OpenJDK 11``
