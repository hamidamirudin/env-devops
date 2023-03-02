# grant docker access to docker host and jenkin container 
Grant Access to Jenkins container : 
- check jenkins id from docker-exec -it jenkins-local id 
- chown 1000:1000 /var/bin/docker

Add docker host login to group docker 
- sudo groupadd docker 
- sudo usermod -aG docker $USER
- relog 
- groups 

# instalasi android sdk di Jenkins (dalam Docker) 

## ada banyak metode nya contoh : 
- install sdk di Docker Host nya 
- install sdk di Jenkins Container 
- install sdk di volume persistent Jenkins nya 

## dibawah ini adalah cara install sdk di Docker Host 

- [1] Install Java (bila belum ada)
(CENTOS)
sudo yum install java-11-openjdk

java -version

export JAVA_HOME=/usr/lib/jvm/jre-11-openjdk-11.0.18.0.10-1.el7_9.x86_64

- [2] ssh ke server Docker Host, masuk ke folder /usr/local/bin
```
ssh root@docker.besmart-universal.com 

cd /usr/local/bin/
```

- [3] Download file cli android terbaru contoh : 
```
curl https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -o commandlinetools-linux-8092744_latest.zip

unzip commandlinetools-linux-8092744_latest.zip -d android_sdk
```

- [4] download sdk dan platformtool terkait 
```
./android_sdk/cmdline-tools/bin/sdkmanager "platform-tools" "platforms;android-32" --sdk_root=android_sdk

./android_sdk/cmdline-tools/bin/sdkmanager "build-tools;32.1.0-rc1" --sdk_root=android_sdk
```

- [5] grant access ke folder android_sdk (not safe but works)
```
chmod -R 777 android_sdk
chmod 777 android_sdk
```

- [6] pastikan Docker Container Jenkins sudah di binding volume nya seperti pada contoh docker-compose.yml disini 
```
...
        volumes:
            - vol_jenkins:/var/jenkins_home 
            - '/usr/local/bin/docker-compose:/usr/local/bin/docker-compose' 
            - '/usr/local/bin/android_sdk:/usr/local/bin/android_sdk'---> disini
...
``` 
- [7] ketika membuat script pipeline Jenkins pastikan environment variable di set dulu, karena image docker jenkins kita tidak mengenali path ANDROID_HOME dll 

contoh pipeline script nya 
```
stage('SetEnv') {
    env.ANDROID_HOME = "/usr/local/bin/android_sdk"
    env.ANDROID_SDK_ROOT = "/usr/local/bin/android_sdk"
    env.PATH="${env.PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
}
```

# Restore Plugin from .bak file 
contoh kalo plugin dengan nama docker-plugin bermasalah maka 
```
cd /var/jenkins_home/plugins
rm -rf docker-plugin
rm -rf docker-plugin.jpi
cp -a docker-plugin.bak docker-plugin.jpi 

```
lalu restart jenkins


# install plugin maven for jenkins on docker host 
``` 
curl https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz --output apache-maven-3.8.6-bin.tar.gz
tar xzvf apache-maven-3.8.6-bin.tar.gz 
cp apache-maven-3.8.6 /opt
```
di docker-compose tambahin di bagian volume 
```
 - '/opt/apache-maven-3.8.6:/opt/maven'
```
restart jenkins container 

kalo akses nya ga ada tambahin dari docker host 
cek id jenkins user di dalam container pakai command $ id 
contoh : 
```
    $ id 
    contoh output 
    uid=1000(jenkins) gid=1000(jenkins) groups=1000(jenkins)
```

```
    docker inspect vol_jenkins 
    # masuk ke folder vol_jenkins
    chown -R 1000:1000 .m2
```

didalam container coba cek bisa panggil mvn ga 

```
    mvn --version 

    #Kalo berhasil harusnya ada output : 
    Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /opt/maven
Java version: 11.0.14.1, vendor: Eclipse Adoptium, runtime: /opt/java/openjdk
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-1160.59.1.el7.x86_64", arch: "amd64", family: "unix"

```


# install plugin oc, Kubectl OKD for jenkins on docker host
Cari download client version yang dibutuhkan di : https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/
```
# Contoh download file 
curl https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-4.10/openshift-client-linux-4.10.30.tar.gz --output oc.tar.gz

#buat directory opt/oc
mkdir /opt/oc

#extract ke dalam folder tersebut ( dalam nya ada oc, kubectl, dan readme)
tar xvzf oc.tar.gz --directory /opt/oc

```
pada docker-compose tambahkan volume mapping : 

```
- '/opt/oc:/opt/oc'
```
Jalankan docker compose ulang dari file (-f) yang sesuai
```
docker-compose -f Jenkins.DockerCompose.yml up -d
```
 
# Install plugin az cli (**`RHEL7/Centos7`**)
Tambahkan *azure-cli* repository:
```
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
```
Install dengan command yum:
```
sudo yum install azure-cli
```

---

# Install plugin az cli (**`Debian/Ubuntu`**) NOT WORKING
`One command Install`:
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

`Step by step installation`:

1. Install package-package yang dibutuhkan: 
```
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
```

2. Download dan instal Microsoft signing key:
```
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
```

3. Add the Azure CLI software repository:
```
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    tee /etc/apt/sources.list.d/azure-cli.list
```

4. Update informasi repository dan install package azure-cli:

```
sudo apt-get update
sudo apt-get install azure-cli
```
---

## INSTALL PYTHON3 CENTOS 7 ##
1. Setup Environment 
yum install gcc openssl-devel bzip2-devel libffi-devel -y

2. Download python
curl -O https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz

tar -xzf Python-3.8.1.tgz

3. Install Python 3
cd Python-3.8.1/
./configure --enable-optimizations
make altinstall

python3.8 -v

export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib

---

## INSTALL Gradle Centos 7 ##


1. Download package
```
wget https://services.gradle.org/distributions/gradle-8.0-bin.zip -P /tmp
```
2.  unzip dan masukan folder /opt/gradle (// harus ada package unzip )
```
sudo unzip -d /opt/gradle /tmp/gradle-8.0-bin.zip
```
3. check  hasil extract
```
ls /opt/gradle/gradle-8.0
```
4. Setup environment variable
```
- sudo nano /etc/profile.d/gradle.sh
export GRADLE_HOME=/opt/gradle/gradle-8.0
export PATH=${GRADLE_HOME}/bin:${PATH}
```
5. Buat script jadi executable
```
sudo chmod +x /etc/profile.d/gradle.sh
```
6. Load environment variable 
```
source /etc/profile.d/gradle.sh
```
7. Verify gradle installation
```
gradle -v
```
8. pada docker-compose tambahkan volume mapping : 
```
- '/opt/gradle/gradle-8.0/bin:/opt/gradle/gradle-8.0/bin'
```

---
## INSTALL FLUTTER SDK LINUX ##

1. Download Flutter SDK:
```
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.7.3-stable.tar.xz -P /tmp
```
2. Extract file Flutter  
```
sudo tar xf /tmp/flutter_linux_3.7.3-stable.tar.xz -C /opt
```
3. Add flutter to env path
```
export PATH="$PATH:/opt/flutter/bin"
```
4. Change owner (asalnya centos)
```
sudo chown -Rv $(whoami) /opt/flutter
```
5. (Optional) Check dependencies need to install
```
flutter doctor
```
6. pada docker-compose tambahkan volume mapping : 
```
- '/opt/flutter/bin:/opt/flutter/bin'
```

---

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