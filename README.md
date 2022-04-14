# Server Tools and Scripts

## Documentation
* [Change Hostname](CHANGE_HOSTNAME.md)
* [Useful for Git](USEFUL_GIT.md)

## Setup

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/initial_setup.sh)"`

## Cleanup 

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/run_clean_up.sh)"`

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
