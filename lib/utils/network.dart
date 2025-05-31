import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../log/logs.dart';

/// 网络状态回调
typedef NetworkCallback = void Function({
  required List<ConnectivityResult> results,
  required bool isConnected,
});

class Network {

  /// 获取当前网络详细状态
  List<ConnectivityResult> get currentResults => _lastResults;
  /// 获取当前是否连接网络
  bool get isConnected => _lastConnected;

  // 静态变量存储单例
  static final Network _instance = Network._internal();
  // 静态方法获取单例实例
  factory Network() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Network._internal();
  // 持久回调列表
  final List<NetworkCallback> _persistentCallbacks = [];
  // 一次性回调列表
  final List<NetworkCallback> _oneTimeCallbacks = [];
  // 网络监听
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  // 网络链接
  final Connectivity _connectivity = Connectivity();
  // 日志工具
  final _logs = Logs();
  // 当前网络状态
  List<ConnectivityResult> _lastResults = [];
  // 当前网络是否连接
  bool _lastConnected = false;

  /// 初始化网络监听
  Future<void> initialize() async {
    _logs.add({_logs.keyTitle: '初始化网络监听', _logs.keySuccess: true});
    // 获取初始状态
    await _checkInitialStatus();
    // 开始监听网络变化
    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }
   /// 添加持久监听回调，网络状态变化时，会调用此方法
  void addPersistentListener(NetworkCallback callback) {
    if (!_persistentCallbacks.contains(callback)) {
      _persistentCallbacks.add(callback);
      // 立即通知当前状态
      callback(results: _lastResults, isConnected: _lastConnected);
    }
  }

  /// 添加一次性监听回调，网络连接成功时，会调用此方法
  void addOneTimeListener(NetworkCallback callback) {
    if (!_oneTimeCallbacks.contains(callback)) {
      _oneTimeCallbacks.add(callback);
      // 如果当前已有网络，立即回调
      if (_lastConnected) {
        _notifyAll(_lastResults, _lastConnected);
      }
    }
  }

  /// 移除持久监听回调
  void removePersistentListener(NetworkCallback callback) {
    _persistentCallbacks.remove(callback);
  }
  
  /// 释放资源
  void dispose() {
    _logs.add({_logs.keyTitle: '释放网络监听', _logs.keySuccess: true});
    // 释放网络监听
    _subscription?.cancel();
    // 清空持久回调列表
    _persistentCallbacks.clear();
    // 清空一次性回调列表
    _oneTimeCallbacks.clear();
    // 清空当前网络状态
    _lastResults = [];
    // 清空当前网络是否连接
    _lastConnected = false;
  }

  /// 检查初始网络状态
  Future<void> _checkInitialStatus() async {
    // 获取初始网络状态
    _lastResults = await _connectivity.checkConnectivity();
    // 获取初始网络是否连接
    _lastConnected = !_lastResults.contains(ConnectivityResult.none);
    // 获取初始网络状态字符串
    final lastResultsString = _lastResults.join(',').replaceAll('ConnectivityResult.', '');
    _logs.add({_logs.keyTitle: '网络状态初检 - $lastResultsString', _logs.keySuccess: _lastConnected, _logs.keyData: lastResultsString});
    // 通知所有回调
    _notifyAll(_lastResults, _lastConnected);
  }

  /// 处理网络变化
  void _handleConnectivityChange(List<ConnectivityResult> results) async {  
    // 当前网络状态
    List<ConnectivityResult> currentResults = results;
    // 获取当前网络是否连接
    bool isConnected = !currentResults.contains(ConnectivityResult.none);
    // 如果是无网络状态，需要二次确认
    if (!isConnected) {
      // 获取初始网络状态
      currentResults = await _connectivity.checkConnectivity();
      // 获取当前网络是否连接
      isConnected = !currentResults.contains(ConnectivityResult.none);
    }
    // 如果当前网络状态与上次不同，或者当前网络状态与上次网络状态不同，则通知所有回调
    if (isConnected != _lastConnected || !listEquals(currentResults, _lastResults)) {
      // 获取当前网络状态字符串
      final resultsString = currentResults.join(',').replaceAll('ConnectivityResult.', '');
      // 记录日志
      _logs.add({_logs.keyTitle: '网络状态变化 - $resultsString', _logs.keySuccess: isConnected, _logs.keyData: resultsString});
      // 更新当前网络状态
      _lastResults = currentResults;
      // 更新当前网络是否连接
      _lastConnected = isConnected;
      // 通知所有回调
      _notifyAll(currentResults, isConnected);
    }
  }

  /// 通知所有回调
  void _notifyAll(List<ConnectivityResult> results, bool isConnected) {
    // 如果当前有网络，则先处理一次性回调
    if (isConnected) {
      // 获取一次性回调列表
      final oneTimeCallbacks = List<NetworkCallback>.from(_oneTimeCallbacks);
      // 清空一次性回调列表
      _oneTimeCallbacks.clear();
      // 遍历一次性回调列表
      for (final callback in oneTimeCallbacks) {
        callback(results: _lastResults, isConnected: _lastConnected);
      }
    }
    // 遍历持久回调列表
    for (final callback in _persistentCallbacks) {
      callback(results: _lastResults, isConnected: _lastConnected);
    }
  }
}
