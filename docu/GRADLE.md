# Speedup Gradle builds

- `/gradle.properties`

```properties
### Project properties ###
projectGroup=eu.koboo
projectVersion=2.0.0
#
### Dependency versions ###
lombokVersion=1.18.24
jupiterVersion=5.9.2
#
### Gradle properties ###
#
# Daemon is true by default
#org.gradle.daemon=true
#
# Enable remote debugging
#org.gradle.debug=true
#org.gradle.debug.port=5005
#
# Enabled parallel building by gradle
org.gradle.parallel=true
#
# Sets the max jvms for gradle tasks (with parallel enabled)
org.gradle.workers.max=8
org.gradle.configureondemand=true
#
# Adds the given args to the gradle tasks
org.gradle.jvmargs=-Xmx2048M
#
# Enables caching of gradle itself
org.gradle.caching=true
#
# Sets the behaviour of stacktrace printing in gradle tasks
# default: internal
# options: internal,all,full
#org.gradle.logging.stacktrace=internal
#
# Sets the log level of gradle
# options: trace, debug, info, warn, warn, error, quit
#org.gradle.logging.level=debug

```

- `/build.gradle`

```groovy
import java.util.stream.Collectors

plugins {
    id('java')
    id('maven-publish')
    id('com.github.johnrengelman.shadow') version('7.1.2')
    id('com.github.breadmoirai.github-release') version('2.4.1')
}

group("$projectGroup")
version("$projectVersion")

repositories {
    mavenCentral()
}

dependencies {
    // Lombok
    compileOnly("org.projectlombok:lombok:$lombokVersion")
    annotationProcessor("org.projectlombok:lombok:$lombokVersion")

    testCompileOnly("org.projectlombok:lombok:$lombokVersion")
    testAnnotationProcessor("org.projectlombok:lombok:$lombokVersion")

    // Jupiter test dependencies
    testImplementation("org.junit.jupiter:junit-jupiter-engine:$jupiterVersion")
    testImplementation("org.slf4j:slf4j-simple:$slf4jVersion")
}

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

task sourcesJar(type: Jar) {
    from sourceSets.main.allJava
    archiveClassifier.set('sources')
}
task javadocJar(type: Jar) {
    from javadoc
    archiveClassifier.set('javadocs')
}

publishing {
    repositories {
        maven {
            url('https://reposilite.koboo.eu/releases')
            credentials {
                username(System.getenv('REPO_USER'))
                password(System.getenv('REPO_TOKEN'))
            }
        }
    }
    publications {
        maven(MavenPublication) {
            from components.java
            artifact sourcesJar
            artifact javadocJar
        }
    }
}

githubRelease {
    token System.getenv('GITHUB_TOKEN')
    generateReleaseNotes = true
    draft = true

    releaseAssets jar.destinationDir.listFiles()

    body { """\
${
        changelog().call()
            .readLines()
            .stream()
            .limit(10)
            .map { "- $it" }
            .collect(Collectors.joining('\n', '## Changelog\n', ''))
    }
- And more..
""" }
}

project.tasks.shadowJar.finalizedBy(project.tasks.javadocJar)
project.tasks.shadowJar.finalizedBy(project.tasks.sourcesJar)
project.tasks.publish.dependsOn(project.tasks.shadowJar)
project.tasks.githubRelease.dependsOn(project.tasks.shadowJar)
```
