## 一、简介（DZMFlutterBaseProject）

* [博客地址](https://blog.csdn.net/zz00008888)

* 删除 `/case` 目录就相当于是个带有基础功能的空项目。

* [AppIcon 与 启动图快捷配置指令](https://blog.csdn.net/zz00008888/article/details/145592305)

## 二、初始化项目环境：

* `$ flutter --version`

  ```sh
  Flutter 3.24.5 • channel stable • https://github.com/flutter/flutter.git
  Framework • revision dec2ee5c1f (10 周前) • 2024-11-13 11:13:06 -0800
  Engine • revision a18df97ca5
  Tools • Dart 3.5.4 • DevTools 2.37.3
  ```

* `$ flutter doctor`

  ```sh
  [✓] Flutter (Channel stable, 3.24.5, on macOS 13.5.2 22G91 darwin-arm64, locale zh-Hans-CN)
  [!] Android toolchain - develop for Android devices (Android SDK version 35.0.0-rc3)
      ! Some Android licenses not accepted. To resolve this, run: flutter doctor --android-licenses
  [✓] Xcode - develop for iOS and macOS (Xcode 15.0)
  [✓] Chrome - develop for the web
  [✓] Android Studio (version 2024.1)
  [✓] VS Code (version 1.96.2)
  [✓] Connected device (5 available)
      ! Error: Browsing on the local area network for 邓泽淼的iPhone. Ensure the device is unlocked and attached with a
        cable or associated with the same local area network as this Mac.
        The device must be opted into Developer Mode to connect wirelessly. (code -27)
  [✓] Network resources
  ```

## 三、包名修改

* `插件 change_app_package_name`

  ```sh
  # 指令
  $ flutter pub run change_app_package_name:main new.package.name

  # 例如：
  $ flutter pub run change_app_package_name:main com.example.newapp
  ```

## 四、应用名称修改

* ### 修改 `Android` 应用名称：
    
  1. 打开 `android/app/src/main/AndroidManifest.xml` 文件，找到 `<application>` 标签。

  1. 修改 `android:label` 属性为新的应用名称：

    ```xml
    <application
        android:label="Your App Name"
        android:icon="@mipmap/ic_launcher">
        ...
    </application>
    ```

* ### 修改 `iOS` 应用名称：
    
  1. 打开 `ios/Runner/Info.plist` 文件，找到 `CFBundleDisplayName` 键。

  1. 修改为新的应用名称：

    ```xml
    <key>CFBundleDisplayName</key>
    <string>Your App Name</string>
    ```

* ### 修改 `Flutter` 内部应用名称：

  1. 打开 `lib/main.dart` 文件。

  1. 修改 `MaterialApp` 小部件中的 `title` 属性：

    ```dart
    MaterialApp(
      title: 'Your App Name',
      home: MyHomePage(),
    );
    ```

* ### 重新构建项目：

  1. 运行以下命令，清理并重新构建项目：

    ```sh
    $ flutter clean
    $ flutter run
    ```

## 三、打包指令

* `Android`

  ```sh
  #【测试】
  $ flutter build apk --debug

  #【测试】使用 appbundle（适用于发布到 Google Play）
  $ flutter build appbundle --debug

  #【正式】
  $ flutter build apk --release

  #【正式】使用 appbundle（适用于发布到 Google Play）
  $ flutter build appbundle --release
  ```

* `iOS`

  ```sh
  #【测试】
  $ flutter build ios --debug
  # 或
  $ flutter build ipa --debug

  #【正式】
  $ flutter build ios --release
  # 或
  $ flutter build ipa --release

  # 推荐通过 Xcode 打包生成
  ```

## 四、插件问题处理

* `iOS` 浏览器报错 [webview_flutter_wkwebview.AuthenticationChallengeResponse](https://blog.csdn.net/zz00008888/article/details/145430050) 解决方案。