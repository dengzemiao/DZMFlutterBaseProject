#!/bin/bash

# 清理
flutter clean

# 获取依赖
flutter pub get

# 进入 ios 目录
cd ./ios || exit 1

# 安装依赖
pod install