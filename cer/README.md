* 证书可获取参数

  包名：
  安卓 - 公钥：
  安卓 - MD5：
  安卓 - SHA1：
  安卓 - SHA256：
  iOS - 公钥：
  iOS - SHA1：
  iOS - .p12：

* 安卓证书相关

  * 生成的 `.keystore` 文件放到 `android/app` 目录下，与 `build.gradle` 文件同级，`validity` 单位为天

    ```sh
    $ keytool -genkeypair -alias dengzemiao -keyalg RSA -keypass dengzemiao123456 -validity 10000 -keystore ./dengzemiao.keystore -storepass dengzemiao123456
    ```

  * 提取证书信息

    0、查看 `.keystore` 签名信息

    ```sh
    $ keytool -list -v -keystore dengzemiao.keystore -alias dengzemiao -keypass dengzemiao123456 -storepass dengzemiao123456 
    ```

    1、生成公钥文件

    ```sh
    # 官方推荐使用 -exportcert 要求 Java 1.4+ ； -export 更老 所有版本

    # .keystore 转 .pem
    $ keytool -exportcert -alias dengzemiao -keystore dengzemiao.keystore -storepass dengzemiao123456 -file public_key.pem

    # .keystore 转 .cer
    $ keytool -exportcert -alias dengzemiao -keystore dengzemiao.keystore -storepass dengzemiao123456 -file public_key.cer
    ```

    2、证书文件类型转换

    ```sh
    # .pem 转 .cer
    $ openssl x509 -in public_key.pem -outform der -out public_key.cer

    # .cer 转 .pem
    openssl x509 -in public_key.cer -inform der -out public_key.pem
    ```

    3、提取公钥信息

    ```sh
    $ openssl x509 -in public_key.pem -text -noout
    ```

    4、提取公钥模数

    ```sh
    $ openssl x509 -in public_key.pem -noout -modulus
    ```

    5、提取 `MD5`

    ```sh
    # .pem 提取 md5
    $ openssl x509 -in public_key.pem -noout -fingerprint -md5
    # 去掉冒号
    $ openssl x509 -in public_key.pem -noout -fingerprint -md5 | tr -d ':'

    # .cer 提取 md5
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -md5
    # 去掉冒号
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -md5 | tr -d ':'
    ```

    6、提取 `SHA1`

    ```sh
    # .keystore 提取 SHA1
    $ keytool -list -v -keystore dengzemiao.keystore -storepass dengzemiao123456 | grep "SHA1:"
    $ keytool -list -v -keystore dengzemiao.keystore -storepass dengzemiao123456 | grep "SHA1:" | awk -F': ' '{print $2}'
    $ keytool -list -v -keystore dengzemiao.keystore -storepass dengzemiao123456 | grep "SHA1:" | awk -F': ' '{print $2}' | tr -d ':'

    # .pem 提取 SHA1
    $ openssl x509 -in public_key.pem -noout -fingerprint -sha1
    # 去掉冒号
    $ openssl x509 -in public_key.pem -noout -fingerprint -sha1 | tr -d ':'

    # .cer 提取 SHA1
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha1
    # 去掉冒号
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha1 | tr -d ':'
    ```

    7、提取 `SHA256`

    ```sh
    # .keystore 提取 SHA1
    $ keytool -list -v -keystore dengzemiao.keystore -storepass dengzemiao123456 | grep "SHA256:"
    $ keytool -list -v -keystore dengzemiao.keystore -storepass dengzemiao123456 | grep "SHA256:" | awk -F': ' '{print $2}'
    $ keytool -list -v -keystore dengzemiao.keystore -storepass dengzemiao123456 | grep "SHA256:" | awk -F': ' '{print $2}' | tr -d ':'

    # .pem 提取 SHA256
    $ openssl x509 -in public_key.pem -noout -fingerprint -sha256
    # 去掉冒号
    $ openssl x509 -in public_key.pem -noout -fingerprint -sha256 | tr -d ':'

    # .cer 提取 SHA256
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha256
    # 去掉冒号
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha256 | tr -d ':'
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