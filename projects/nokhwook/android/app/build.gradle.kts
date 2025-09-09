import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

//val keyFile = rootProject.file("key.properties")
//val keyProperties = Properties()

// Load key properties for signingConfigs
//keyProperties.load(FileInputStream(keyFile))

android {
    //signingConfigs {
    //    create("debug") {
    //      keyAlias = keyProperties["keyAlias"] as String
    //      keyPassword = keyProperties["keyPassword"] as String
    //      storeFile = file(keyProperties["storeFile"] as String)
    //      storePassword = keyProperties["storePassword"] as String
    //    }
    //    create("release") {
    //      keyAlias = keyProperties["keyAlias"] as String
    //      keyPassword = keyProperties["keyPassword"] as String
    //      storeFile = file(keyProperties["storeFile"] as String)
    //      storePassword = keyProperties["storePassword"] as String
    //    }
    //}

    namespace = "com.doiapps.nokhwook"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.doiapps.nokhwook"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    implementation("com.android.support:multidex:1.0.3")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
