# Speedup Gradle builds

- `/gradle.properties`

```properties
### Gradle properties ###

# Daemon is true by default
#org.gradle.daemon=true

# Enable remote debugging
#org.gradle.debug=true
#org.gradle.debug.port=5005

# Enabled parallel building by gradle
org.gradle.parallel=true

# Sets the max jvms for gradle tasks (with parallel enabled)
org.gradle.workers.max=8

# Adds the given args to the gradle tasks
org.gradle.jvmargs=-Xmx2048M

# Enables caching of gradle itself
org.gradle.caching=true

# Sets the behaviour of stacktrace printing in gradle tasks
# default=internal
# internal,all,full
#org.gradle.logging.stacktrace=internal

#########################
```

- `/build.gradle`

```groovy
test {
    useJUnitPlatform()
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

tasks.withType(JavaCompile).configureEach {
    options.fork = true
    options.encoding = 'UTF-8'
}

publishing {
    repositories {
        maven {
            url 'https://reposilite.koboo.eu/releases'
            credentials {
                username System.getenv('REPO_USER')
                password System.getenv('REPO_TOKEN')
            }
        }
    }
    publications {
        maven(MavenPublication) {
            from components.java
        }
    }
}
```
