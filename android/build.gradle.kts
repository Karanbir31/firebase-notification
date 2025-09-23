buildscript {
    repositories {
        google()   // Make sure this is present
        mavenCentral()
    }
    dependencies {
        // Keep your existing Android Gradle plugin
        classpath("com.android.tools.build:gradle:8.3.1") // replace with your version if different

        // Add Google Services plugin for Firebase
        classpath("com.google.gms:google-services:4.4.3") // latest stable

    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }


}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
