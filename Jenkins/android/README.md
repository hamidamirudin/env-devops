## CARA COMPILE APK-RELEASE APP REACT ## 

1. Install react native cli 
```
npm install -g react-native-cli
```
2. Create Keytool
```
keytool -genkey -v -keystore your_key_name.keystore -alias your_key_alias -keyalg RSA -keysize 2048 -validity 10000 <!-- *Password harus diingat>
```
3. Move Keystore to /android/app
```
mv my-release-key.keystore /android/app
```
4. Edit android/app/build.gradle. Ada 2 cara:

<!-- UNSECURED WAY -->
```
android {
....
  signingConfigs {
    release {
      storeFile file('your_key_name.keystore')
      storePassword 'your_key_store_password'
      keyAlias 'your_key_alias'
      keyPassword 'your_key_file_alias_password'
    }
  }
  buildTypes {
    release {
      ....
      signingConfig signingConfigs.release
    }
  }
}
```

<!-- PASSWORD WILL PROMPT (more secure) -->
```
signingConfigs {
  release {
    storeFile file('your_key_name.keystore')
    storePassword System.console().readLine("\nKeystore password:")
    keyAlias System.console().readLine("\nAlias: ")
    keyPassword System.console().readLine("\nAlias password: ")
   }
}
```

5. Create react native bundle
```
react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res/
```
6. Compile APK Release
```
- cd /android
- ./gradlew assembleRelease <!-- Linux -->
- gradlew assembleRelease
```
**Hasil compile android react native ada di**:  `android/app/build/outputs/apk/release/app-release.apk`

---
