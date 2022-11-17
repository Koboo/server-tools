# // _Server Tools and Scripts_

## Links
- [Git Paper](docu/USEFUL_FOR_GIT.md)
- [Dropbox Paper](docu/INSTALL_DROPBOX.md)
- [Gradle Paper](docu/GRADLE.md)
- [JDK17 Paper](docu/JDK17.md)
- [Jarfix](docu/JAR_FIX.md)
- [Bash Snippets](https://github.com/alexanderepstein/Bash-Snippets)
- [Change Hostname](docu/CHANGE_HOSTNAME.md)
- [WTFPL](http://www.wtfpl.net/about/)

## Files
- [EditorConfig](.editorconfig)
- [GitIgnore](.gitignore)

## Setup Debian 10/11 machines

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/initial_setup.sh)"`

## Cleanup Debian 10/11 machines

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/clean_up.sh)"`

## Benchmark Debian 10/11 machines

`wget -qO- bench.sh | bash`

## Check required MongoDB CPU Flags

`bash -c "$(wget -O - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/check_mongodb_cpu_flags.sh)"`

## Java Installation

#### Script

`wget - https://raw.githubusercontent.com/Koboo/server-tools/main/scripts/java_mgmt.sh`

Available JDK Versions:

* (5) ``GraalVM 11``
* (4) ``GraalVM 17``
* (3) ``Corretto 17``
* (2) ``OpenJDK 17``
* (1) ``OpenJDK 11``
