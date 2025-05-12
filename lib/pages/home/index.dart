import 'package:flutter/material.dart';
import 'package:base_project/base/refresh/index.dart';
import 'package:base_project/utils/public.dart';
class HomeController extends BaseRefreshController {

  const HomeController({super.key, super.title});

  @override
  HomeControllerState createState() => HomeControllerState();
}

class HomeControllerState extends BaseRefreshControllerState with WidgetsBindingObserver {
  @override
  void initStateContext() {
    super.initStateContext();
    // 检查网络状态
    // 添加持久监听，网络状态变化时，会调用此方法
    network.addPersistentListener(_handleNetworkChange);
    // 添加一次性监听，网络连接成功时，会调用此方法
    network.addOneTimeListener(({required results, required isConnected}) {
      log('network.addOneTimeListener: $isConnected');
      if (isConnected) {
        // 操作当前页面的网络数据
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 持久监听如果不需要，需要手动移除
    network.removePersistentListener(_handleNetworkChange);
  }

  /// 网络状态变化回调
  void _handleNetworkChange({required results, required isConnected}) {
    log('network.addPersistentListener: $isConnected');
    if (isConnected) {
      // 操作当前页面的网络数据
    }
  }
}