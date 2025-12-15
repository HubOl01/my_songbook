import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Загрузка keystore
val keystoreProperties = Properties().apply {
    val keystoreFile = rootProject.file("key.properties")
    if (keystoreFile.exists()) {
        load(keystoreFile.inputStream())
    }
}

// Загрузка локальных переменных (flutter.versionCode и versionName)
val localProperties = Properties().apply {
    val localFile = rootProject.file("local.properties")
    if (localFile.exists()) {
        localFile.reader(Charsets.UTF_8).use { load(it) }
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "ru.ru_developer.my_songbook"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "ru.ru_developer.my_songbook"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }

    buildFeatures {
        viewBinding = true
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }
}

kotlin {
    jvmToolchain(21)
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.play:core:1.10.3")
    implementation("com.google.android.play:core-ktx:1.8.1")
    implementation("com.yandex.android:mobileads:7.18.0")
    implementation ("com.yandex.ads.mediation:mobileads-applovin:13.1.0.11")
    implementation ("com.yandex.ads.mediation:mobileads-appnext:2.7.6.473.19")
    implementation ("com.yandex.ads.mediation:mobileads-bigoads:5.5.1.2")
    implementation ("com.yandex.ads.mediation:mobileads-chartboost:9.3.1.27")
    implementation ("com.yandex.ads.mediation:mobileads-adcolony:4.8.0.14")
    implementation ("com.yandex.ads.mediation:mobileads-google:23.6.0.10")
    implementation ("com.yandex.ads.mediation:mobileads-inmobi:10.8.7.2")
    implementation ("com.yandex.ads.mediation:mobileads-ironsource:9.0.0.0")
    implementation ("com.yandex.ads.mediation:mobileads-mytarget:5.27.4.0")
}
