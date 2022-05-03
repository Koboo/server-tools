# Server Tools and Scripts

## Documentation
* [Change Hostname](docu/CHANGE_HOSTNAME.md)
* [Useful for Git](docu/USEFUL_FOR_GIT.md)
* [Bash Snippets](https://github.com/alexanderepstein/Bash-Snippets)

## Setup

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/initial_setup.sh)"`

#### ToDo
* [Timezone setting](https://linuxize.com/post/how-to-set-or-change-timezone-on-debian-10/)
* Make Java and Cleanup Global commands through Initial setup

## Cleanup 

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/clean_up.sh)"`

## Benchmark

`wget -qO- bench.sh | bash`

## Java Installation

#### Script

`wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh`

#### Install GraalVM 11

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh)" '' -i 5`

#### Install GraalVM 17

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh)" '' -i 2`

#### Install Corretto 17

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh)" '' -i 3`

#### Install OpenJDK 17

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh)" '' -i 4`

#### Install OpenJDK 11

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh)" '' -i 5`
