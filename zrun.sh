#!/bin/bash

# 清理
flutter clean

# 获取依赖
flutter pub get

# 删除 Pods 目录
rm -rf ios/Pods

# 删除 Podfile.lock 文件
rm ios/Podfile.lock

# 进入 ios 目录并安装依赖
cd ios && pod install