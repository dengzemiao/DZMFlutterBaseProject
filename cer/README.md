* 安卓证书相关

  * 生成的 `.keystore` 文件放到 `android/app` 目录下，与 `build.gradle` 文件同级，`validity` 单位为天

    ```sh
    $ keytool -genkeypair -alias dengzemiao -keyalg RSA -keypass dengzemiao123456 -validity 10000 -keystore ./dengzemiao.keystore -storepass dengzemiao123456
    ```

  * 提取证书信息

    1、生成公钥文件

    ```sh
    $ keytool -export -alias dengzemiao -keystore dengzemiao.keystore -storepass dengzemiao123456 -file public_key.pem
    ```

    2、提取公钥信息

    ```sh
    $ openssl x509 -in public_key.pem -text -noout
    ```

    3、提取公钥模数

    ```sh
    $ openssl x509 -in public_key.pem -noout -modulus
    ```

    3、提取 `MD5`

    ```sh
    $ openssl x509 -in public_key.pem -noout -fingerprint -md5

    # 去掉冒号
    $ openssl x509 -in public_key.pem -noout -fingerprint -md5 | tr -d ':'
    ```

    4、提取 `SHA1`

    ```sh
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha1

    # 去掉冒号
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha1 | tr -d ':'
    ```

    5、查看 `.keystore` 签名信息

    ```sh
    $ keytool -list -v -keystore dengzemiao.keystore -alias dengzemiao -keypass dengzemiao123456 -storepass dengzemiao123456 
    ```

  * 提取 `aab/apk` 证书信息

    1、`aab` 生成 `apk`，下载[bundletool](https://github.com/google/bundletool/releases)，如 `bundletool-all-x.x.x.jar`，下载后改名为 `bundletool-all.jar` 方便使用，`app-release.aab` 改成自己打包出来的。

    ```sh
    $ java -jar bundletool-all.jar build-apks --bundle=app-release.aab --output=temp.apks --mode=universal
    ```

    2、解压 `apks` 文件，生成的 `temp.apks` 是一个 ZIP 文件，解压后得到 `universal.apk`

    ```sh
    $ unzip temp.apks -d temp
    ```

    3、输出 `apk` 签名信息

    ```sh
    $ keytool -printcert -jarfile temp/universal.apk
    ```

    4、获取 `apk` `MD5` 信息（`Android SDK` 工具）

    ```sh
    $ apksigner verify --print-certs temp/universal.apk | grep -i "md5"
    ```
    
包名：
安卓 - 公钥：
安卓 - MD5：D7:DA:F9:FB:F2:85:F8:9F:75:3C:72:E5:37:72:AD:D6
安卓 - SHA1：4D:14:92:97:F4:F7:29:49:CF:47:C7:82:E0:67:84:AD:DD:26:54:F3
安卓 - SHA256：9E:AC:30:E7:89:C6:B8:C6:42:E0:1B:C9:EA:39:22:0B:54:86:18:A0:5B:3B:78:D4:9B:A7:86:CE:DF:93:3D:88
iOS - 公钥：
iOS - SHA1：
iOS - .p12：