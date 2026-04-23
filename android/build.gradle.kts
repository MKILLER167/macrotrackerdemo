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

subprojects {
    fun applyNamespaceFix(p: Project) {
        if (p.hasProperty("android")) {
            val android = p.extensions.findByName("android")
            if (android != null) {
                try {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    if (getNamespace.invoke(android) == null) {
                        val ns = if (p.name == "qr_code_scanner") {
                            "net.touchcapture.qr.flutter.qr_code_scanner"
                        } else {
                            p.group.toString().ifEmpty { "com.example.${p.name.replace("-", "_")}" }
                        }
                        setNamespace.invoke(android, ns)
                    }
                } catch (e: Exception) {
                }
            }
        }
    }

    if (project.state.executed) {
        applyNamespaceFix(project)
    } else {
        project.afterEvaluate {
            applyNamespaceFix(project)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
