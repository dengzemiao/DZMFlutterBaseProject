import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../log/logs.dart';

class Permission {

  /// 静态变量存储单例
  static final Permission _instance = Permission._internal();
  // 静态方法获取单例实例
  factory Permission() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Permission._internal();
  // 日志工具
  final _logs = Logs();

  /// 监听网络状态（获取到有网络则停止监听）
  /// [callback] 回调函数，参数为是否连接
  Future<void> listenNetworkOnce([ValueChanged<bool>? callback]) async {
    // 立即检查当前状态
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    // 如果连接，直接返回
    if (!results.contains(ConnectivityResult.none)) {
      if (callback != null) { callback(true); }
      return;
    }
    // 如果没有网络，监听一段时间（如正在切换网络）
    late final StreamSubscription<List<ConnectivityResult>> sub;
    sub = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // 如果连接，直接返回
      if (!results.contains(ConnectivityResult.none)) {
        // 发现有效连接后取消监听
        sub.cancel();
        if (callback != null) { callback(true); }
      }
    });
  }

  /// 监听网络状态（持续一直监听）
  /// [callback] 回调函数，参数为是否连接
  StreamSubscription<List<ConnectivityResult>> listenNetwork([ValueChanged<bool>? callback]) {
    // 如果没有网络，监听一段时间（如正在切换网络）
    return listenNetworkResults((List<ConnectivityResult> results) {
      // 如果连接，直接返回
      if (results.contains(ConnectivityResult.none)) {
        if (callback != null) { callback(false); }
      } else {
        if (callback != null) { callback(true); }
      }
    });
  }

  /// 监听网络状态（持续一直监听）
  /// [callback] 回调函数，网络状态结果
  StreamSubscription<List<ConnectivityResult>> listenNetworkResults([ValueChanged<List<ConnectivityResult>>? callback]) {
    return Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
       // 收到可用连接类型的变化
      if (results.contains(ConnectivityResult.mobile)) {
        // 移动网络可用
        _logs.add({_logs.keyTitle: '移动网络可用', _logs.keySuccess: true});
      } else if (results.contains(ConnectivityResult.wifi)) {
        // Wi-Fi 可用
        // 注意：对于 Android：
        // 当移动数据和 Wi-Fi 都打开时，系统会返回 Wi-Fi 作为唯一的活动网络类型
        _logs.add({_logs.keyTitle: 'Wi-Fi 可用', _logs.keySuccess: true});
      } else if (results.contains(ConnectivityResult.ethernet)) {
        // 以太网连接可用
        _logs.add({_logs.keyTitle: '以太网连接可用', _logs.keySuccess: true});
      } else if (results.contains(ConnectivityResult.vpn)) {
        // VPN 连接活动
        // 注意：对于 iOS 和 macOS：
        // 对于 [vpn]，没有单独的网络接口类型。
        // 它会在任何设备（包括模拟器）上返回 [other]
        _logs.add({_logs.keyTitle: 'VPN 连接活动', _logs.keySuccess: true});
      } else if (results.contains(ConnectivityResult.bluetooth)) {
        // 蓝牙连接可用
        _logs.add({_logs.keyTitle: '蓝牙连接可用', _logs.keySuccess: true});
      } else if (results.contains(ConnectivityResult.other)) {
        // 连接到一个未在上述网络类型中的网络
        _logs.add({_logs.keyTitle: '连接到一个未在上述网络类型中的网络', _logs.keySuccess: true});
      } else if (results.contains(ConnectivityResult.none)) {
        // 没有可用的网络类型
        _logs.add({_logs.keyTitle: '没有可用的网络类型', _logs.keySuccess: false});
      }
      // 回调
      if (callback != null) { callback(results); }
    });
  }
}
