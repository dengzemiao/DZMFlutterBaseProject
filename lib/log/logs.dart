import 'dart:io';
import 'package:flutter/material.dart';
import '../model/account.dart';
import '../utils/storage.dart';
import '../utils/hud.dart';
import './button.dart';

class Logs {

  /// 示例：
  /// 
  /// logs.add({
  ///   'title': '个人信息',
  ///   'data': accountModel.toJson() // 只要不与下面字段冲突，命名随意，数据格式随意
  /// })
  /// 
  /// logs.add({
  ///   logs.keyTitle: '个人信息',
  ///   logs.keyData: accountModel.toJson() // 只要不与下面字段冲突，命名随意，数据格式随意
  /// })
  
  /// 参数 Key，并不是只能传这些，额外字段可以随时添加不做限制，列出来固定只是方便统一管理，需要额外字段可以随意添加
  
  /// ===>>> 常规参数

  ///【非必填】日志标题，会有默认标题
  final String keyTitle = 'title';
  ///【非必填】日志数据，存放日志数据
  final String keyData = 'data';
  ///【非必填】日志状态，true 成功 false 失败/错误，会有不同的展示颜色，默认 true
  final String keySuccess = 'success';

  /// ===>>> 日志触发参数
  
  ///【非必填】日志触发时间，会自动获取当前时间
  final String keyDate = 'date';
  ///【非必填】日志展开、收起状态， false 收起，true 展开，默认取 isExpanded 字段值
  final String keyExpand = 'expand';
  ///【非必填】日志索引，会自动递增，不能进行操作
  final String keyIndex = 'index';

  /// ===>>>【 需要用户可后续添加的其他常规参数 】 
  
  /// 日志触发设备平台，默认不需要调整
  final String keyPlatform = 'platform';
  /// 日志触发用户ID
  final String keyUserId = 'userId';

  /// ===>>>【 日志对象属性 】
  
  /// 日志开启状态
  bool _isEnable = false;
  /// 获取日志开启状态
  bool get isEnable => _isEnable;
  /// 切换日志开关埋点位置的计数器
  int enableCounter = 0;
  /// 需要除非计数器多少次才切换日志开关
  int enableCounterNumber = 15;
  /// 切换日志开关次数计数器
  int enableDevCounter = 0;
  /// 需要切换多少下开关才能切换接口环境
  int enableDevCounterNumber = 15;
  /// 日志列表
  final List<Map<String, dynamic>> _logs = [];
  /// 获取日志列表
  List<Map<String, dynamic>> get logs => _logs;
  /// 日志展开状态
  bool isExpanded = false;
  /// 是否进入了日志页面，防止进入日志页面后重复跳转
  bool isInTheLogPage = false;
  
  // 静态变量存储单例
  static final Logs _instance = Logs._internal();
  // 静态方法获取单例实例
  factory Logs() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Logs._internal() {
    // 同步状态，但是每次启动会有首屏会有延迟，推荐在 main.dart 中调用一次，等待加载完成状态在初始化页面最佳
    // sync();
  }

  /// 同步状态
  Future<bool> sync() async {
    // 获取日志开启状态
    _isEnable = await Storage().getBoolPro('LogsEnable', defaultValue: true);
    // _isEnable = await Storage().getBoolPro('LogsEnable', defaultValue: false);
    // 返回
    return _isEnable;
  }

  /// 显示日志按钮
  /// 在 initState 中实现需要加载完成后再添加，避免报错，示例：
  /// WidgetsBinding.instance.addPostFrameCallback((_) {
  ///   LogButton.show(context);
  /// });
  void showButton(BuildContext context) {
    // 添加日志按钮
    LogButton.show(context);
  }
  
  /// 移除日志按钮，并清空日志记录
  void removeButton() {
    // 移除日志按钮
    LogButton.remove();
    // 清空日志
    clear();
  }

  /// 切换日志开关
  void enable(bool value, {BuildContext? context}) {
    // 更新状态
    _isEnable = value;
    // 存储状态
    Storage().setBool('LogsEnable', value);
    // 判断状态
    if (_isEnable) {
      // 上下文是否有值
      if (context != null) {
        Hud().showToast('日志已开启');
        // 切换日志开关
        showButton(context);
      } else {
        // 日志记录不影响，只是日志按钮需要切换页面后才显示
        Hud().showToast('日志已开启，切换页面后出现日志按钮');
      }
    } else {
      Hud().showToast('日志已关闭');
      // 移除日志按钮
      removeButton();
    }
  }

  /// 添加日志
  void add(Map<String, dynamic> log) {
    // 是否开启日志
    if (_isEnable) {
      // 日志标题
      if (log[keyTitle] == null) log[keyTitle] = '日志';
      // 日志状态 true 成功 false 失败/错误，会有不同的展示颜色
      if (log[keySuccess] == null) log[keySuccess] = true;
      // 当前索引
      log[keyIndex] = _logs.length;
      // 展开、收起
      log[keyExpand] = isExpanded;
      // 当前时间
      log[keyDate] = DateTime.now().toString();
      // 当前平台
      log[keyPlatform] = Platform.operatingSystem;
      // 当前用户ID
      log[keyUserId] = AccountModel().userInfo?.id ?? '';
      // 添加日志
      // _logs.add(log);
      _logs.insert(0, log);
    }
  }

  /// 清空日志
  void clear() {
    _logs.clear();
  }
}