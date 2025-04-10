import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  
  /// 私有构造函数，确保单例模式
  Storage._internal();

  /// 单例实例
  static final Storage _instance = Storage._internal();

  /// 获取单例实例
  factory Storage() { return _instance; }

  /// 获取 SharedPreferences 实例
  Future<SharedPreferences> _getStorage() async {
    return await SharedPreferences.getInstance();
  }

  /// 存储字符串
  Future<bool> setString(String key, String value) async {
    final storage = await _getStorage();
    return storage.setString(key, value);
  }

  /// 获取字符串，如果没有则返回默认值（可能没有值，返回 null）
  Future<String?> getString(String key, {String? defaultValue}) async {
    final storage = await _getStorage();
    return storage.getString(key) ?? defaultValue;
  }

  /// 获取字符串，如果没有则返回默认值（一定返回一个基础的默认值，如 ''）
  Future<String> getStringPro(String key, {String defaultValue = ''}) async {
    final storage = await _getStorage();
    return storage.getString(key) ?? defaultValue;
  }

  /// 存储整数
  Future<bool> setInt(String key, int value) async {
    final storage = await _getStorage();
    return storage.setInt(key, value);
  }

  /// 获取整数，如果没有则返回默认值（可能没有值，返回 null）
  Future<int?> getInt(String key, {int? defaultValue}) async {
    final storage = await _getStorage();
    return storage.getInt(key) ?? defaultValue;
  }

  /// 获取整数，如果没有则返回默认值（一定返回基础默认值，如 0）
  Future<int> getIntPro(String key, {int defaultValue = 0}) async {
    final storage = await _getStorage();
    return storage.getInt(key) ?? defaultValue;
  }

  /// 存储布尔值
  Future<bool> setBool(String key, bool value) async {
    final storage = await _getStorage();
    return storage.setBool(key, value);
  }

  /// 获取布尔值，如果没有则返回默认值（可能没有值，返回 null）
  Future<bool?> getBool(String key, {bool? defaultValue}) async {
    final storage = await _getStorage();
    return storage.getBool(key) ?? defaultValue;
  }

  /// 获取布尔值，如果没有则返回默认值（一定返回基础默认值，如 false）
  Future<bool> getBoolPro(String key, {bool defaultValue = false}) async {
    final storage = await _getStorage();
    return storage.getBool(key) ?? defaultValue;
  }

  /// 存储双精度浮点数
  Future<bool> setDouble(String key, double value) async {
    final storage = await _getStorage();
    return storage.setDouble(key, value);
  }

  /// 获取双精度浮点数，如果没有则返回默认值（可能没有值，返回 null）
  Future<double?> getDouble(String key, {double? defaultValue}) async {
    final storage = await _getStorage();
    return storage.getDouble(key) ?? defaultValue;
  }

  /// 获取双精度浮点数，如果没有则返回默认值（一定返回基础默认值，如 0.0）
  Future<double> getDoublePro(String key, {double defaultValue = 0.0}) async {
    final storage = await _getStorage();
    return storage.getDouble(key) ?? defaultValue;
  }

  /// 存储字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    final storage = await _getStorage();
    return storage.setStringList(key, value);
  }

  /// 获取字符串列表，如果没有则返回默认值（可能没有值，返回 null）
  Future<List<String>?> getStringList(String key, {List<String>? defaultValue}) async {
    final storage = await _getStorage();
    return storage.getStringList(key) ?? defaultValue;
  }

  /// 获取字符串列表，如果没有则返回默认值（一定返回基础默认值，如空列表 []）
  Future<List<String>> getStringListPro(String key, {List<String> defaultValue = const []}) async {
    final storage = await _getStorage();
    return storage.getStringList(key) ?? defaultValue;
  }

  /// 删除数据
  Future<bool> remove(String key) async {
    final storage = await _getStorage();
    return storage.remove(key);
  }

  /// 清除所有数据
  Future<void> clear() async {
    final storage = await _getStorage();
    await storage.clear();
  }
}
