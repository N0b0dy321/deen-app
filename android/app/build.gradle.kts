import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val mapsApiKey = localProperties.getProperty("MAPS_API_KEY") ?: ""

// ── อ่านค่าเซ็น release จาก key.properties ───────────────────────
// (ไฟล์นี้เก็บรหัสผ่าน/path ของ keystore จริง ห้าม commit ขึ้น git —
// ต้องอยู่ใน .gitignore แล้ว)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.deenapp.deen"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true  // เพิ่มตรงนี้
    }

    defaultConfig {
        applicationId = "com.deenapp.deen"
        minSdk = flutter.minSdkVersion  // ต้องเป็น 21 ขึ้นไป
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // กฎกัน R8 ตัดโค้ดของปลั๊กอินแจ้งเตือน (ดูไฟล์ proguard-rules.pro)
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
            // ใช้ key.properties ถ้ามี (ไฟล์ release จริง) ไม่งั้น fallback ไปใช้ debug key
            // ชั่วคราว กัน build พังตอนยังไม่ได้ตั้งค่า keystore (เช่นตอน dev)
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")  // เพิ่มตรงนี้
}

flutter {
    source = "../.."
}