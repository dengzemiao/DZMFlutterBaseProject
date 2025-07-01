#!/bin/bash
set -e

# 日志
echo "开始 Flutter + iOS + Android 全缓存清理与依赖更新流程..."

# Flutter 清理旧构建缓存
flutter clean

# Flutter pub 缓存修复（可选，日常清理可不执行，耗时较长）
# flutter pub cache repair

# iOS 原生依赖清理
rm -rf ios/Pods
rm -f ios/Podfile.lock

# CocoaPods 缓存清理（可选，日常清理可不执行）
# pod cache clean --all

# Android 原生构建缓存清理
cd android
./gradlew clean --no-build-cache
rm -rf .gradle build
cd ..

# Flutter 重新获取 Dart 依赖
flutter pub get

# iOS 重新安装 CocoaPods 依赖
cd ios
pod install
cd ..

# 日志
echo "缓存清理和依赖更新完成！"
