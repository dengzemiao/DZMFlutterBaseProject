* 安卓证书相关

  * 生成的 `.keystore` 文件放到 `android/app` 目录下，与 `build.gradle` 文件同级

    ```sh
    $ keytool -genkeypair -alias dengzemiao -keyalg RSA -keypass dengzemiao123456 -validity 10000 -keystore ./dengzemiao.keystore -storepass dengzemiao123456
    ```

  * 提取

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

    3、提取 MD5

    ```sh
    $ openssl x509 -in public_key.pem -noout -fingerprint -md5

    # 去掉冒号
    $ openssl x509 -in public_key.pem -noout -fingerprint -md5 | tr -d ':'
    ```

    4、提取 SHA1

    ```sh
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha1

    # 去掉冒号
    $ openssl x509 -in public_key.cer -inform der -noout -fingerprint -sha1 | tr -d ':'
    ```

    5、查看 `.keystore` 签名信息

    ```sh
    $ keytool -list -v -keystore dengzemiao.keystore -alias dengzemiao
    ```
    
包名：
安卓 - 公钥：
安卓 - MD5：
安卓 - SHA1：
安卓 - SHA256：
iOS - 公钥：
iOS - SHA1：
iOS - .p12：