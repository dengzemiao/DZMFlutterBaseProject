#!/bin/bash
set -e

GREEN_BG="\033[42m"
RESET="\033[0m"

echo "${GREEN_BG}============================== 开始 Flutter + iOS + Android 全缓存清理与依赖更新流程...${RESET}"

# Flutter 清理旧构建缓存
flutter clean
echo "${GREEN_BG}============================== Flutter clean 完成${RESET}"

# Flutter pub 缓存修复（可选，日常清理可不执行，耗时较长）
flutter pub cache repair
echo "${GREEN_BG}============================== Flutter pub cache repair 完成${RESET}"

# iOS 原生依赖清理
rm -rf ios/Pods
rm -f ios/Podfile.lock
echo "${GREEN_BG}============================== iOS Pods 和 Podfile.lock 删除完成${RESET}"

# CocoaPods 缓存清理（可选，日常清理可不执行）
# pod cache clean --all
# echo "${GREEN_BG}============================== CocoaPods 缓存清理完成${RESET}"

# Android 原生构建缓存清理
cd android
./gradlew clean --no-build-cache
rm -rf .gradle build
cd ..
echo "${GREEN_BG}============================== Android 构建缓存清理完成${RESET}"

# Flutter 重新获取 Dart 依赖
flutter pub get
echo "${GREEN_BG}============================== Flutter pub get 完成${RESET}"

# iOS 重新安装 CocoaPods 依赖
cd ios
pod install
cd ..
echo "${GREEN_BG}============================== iOS pod install 完成${RESET}"

echo "${GREEN_BG}============================== 缓存清理和依赖更新完成！${RESET}"
