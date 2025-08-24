plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.uploadassignmentapplication"
    compileSdk = flutter.compileSdkVersion

    // ✅ NDK version should be assigned with '=' instead of just writing the value
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.uploadassignmentapplication"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

   buildTypes {
    release {
        // Enable code shrinking + resource shrinking for release
        isMinifyEnabled = true
        isShrinkResources = true

        // Use ProGuard rules file
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )

        signingConfig = signingConfigs.getByName("debug")
    }

    debug {
        // Disable shrinking for debug builds
        isMinifyEnabled = false
        isShrinkResources = false
    }
}

}

flutter {
    source = "../.."
}
