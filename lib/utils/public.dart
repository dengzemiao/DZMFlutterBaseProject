import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:base_project/routes/index.dart';
import 'package:base_project/components/app_update.dart';
import 'package:base_project/model/account.dart';
import 'package:base_project/model/app_update.dart';
import './constant.dart';
import './network.dart';
import './storage.dart';
import './camera.dart';
import './navigator.dart';
import './hud.dart';
import './payment.dart';
import './date.dart';
import './device.dart';
import '../log/logs.dart';
import '../api/request.dart';

/// ================================================ 公共单例 / 常量

/// 账户信息
final accountModel = AccountModel();
/// 路由观察者
final routeObserver = RouteObserver<PageRoute>();
/// 导航工具
final nav = Nav();
/// 支付工具
final pay = Payment();
/// 网络工具
final network = Network();
/// Loading 工具
final hud = Hud();
/// 日志工具
final logs = Logs();
/// 相机工具
final camera = Camera();
/// 路由对象
final appRoutes = AppRoutes();
/// 请求对象
final appRequest = AppRequest();
/// 存储实例
final storage = Storage();
/// 时间工具
final date = Date();
/// 设备工具
final device = Device();

/// 导航条高度
final navBarHeight = adaptSize(54.0);
/// 底部功能条高度
final bottomToolBarHeight = adaptSize(58.0);
/// 是否强制打开所有请求输出日志
const bool showRequestLog = false;
/// 隐私政策协议地址
const String agrPrivacyUrl = 'https://edu.shieye-property.com/agr-privacy.html';
/// 服务协议地址
const String agrServerUrl = 'https://edu.shieye-property.com/agr-server.html';
/// 是否是调试模式
// kDebugMode: 为 true 时表示处于 调试模式。
// kReleaseMode: 为 true 时表示处于 发布模式。
// kProfileMode: 为 true 时表示处于 性能分析模式。
bool? isDebugMode;
/// 包信息
PackageInfo? packageInfo;
/// 默认头像
String defaultAvatarUrl = 'assets/images/image_avatar.png';

/// ================================================ 公共系统函数

/// DeepLinks 处理，例如 dengzemiao:///pages/player?id=123
void deepLinksHandle(Uri? link) {
  // 有值
  if (link != null) {
    // 进日志页面，dengzemiao:///log || snapdrama:///?openlog=true
    if (link.path == appRoutes.logvc || link.queryParameters.containsKey('openlog')) {
      // 打开/关闭日志
      logs.enable(true);
      // 延迟 1 秒跳转页面
      Future.delayed(const Duration(seconds: 1), () {
        // 跳转页面
        nav.toNamed(appRoutes.logvc);
      });
    }
  }
}

/// App 是否进行更新
void initAppUpdate(BuildContext context) async {
  // 检查是否需要更新
  try {
    // 发起网络请求
    final params = {
      'current_version': packageInfo?.version ?? '1.0.0',
      // 1 Android, 2 iOS
      'operating_system': Platform.isAndroid ? 1 : 2,
    };
    // 检查
    final response = await appRequest.checkVersion(params);
    // 检查更新
    if (response.code == 0) {
      // 检查更新
      final appUpdateModel = AppUpdateModel.fromJson(response.data['app_version']);
      // 版本比较
      if (Version.parse(appUpdateModel.latestVersion ?? '1.0.0') > Version.parse(packageInfo?.version ?? '1.0.0')) {
        // 弹出更新
        if (context.mounted) {
          AppUpdate.show(
            context: context,
            model: appUpdateModel,
          );
        }
      }
    }
  } catch (_) {}
}

/// 日志输出
void log(Object? object, [String? title]) {
  if (kDebugMode) {
    print('================================================== ${ title ?? '' }');
    print(object);
    print('==================================================');
  }
}

/// 状态栏高度
double getStatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}
/// 底部安全区域高度
double getBottomSafeAreaHeight(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}
/// 获取屏幕可用高度（是否有导航栏、底部TabBar）
double getAvailableScreenHeight(
  BuildContext context, 
  {
    bool hasStatusBar = true,
    bool hasAppBar = true,
    bool hasBottomTabBar = true,
    bool hasBottomSafeArea = true,
  }
) {
  final mediaQuery = MediaQuery.of(context);
  final screenHeight = mediaQuery.size.height;
  // 顶部高度（状态栏 + AppBar）
  final statusBarHeight = hasStatusBar ? mediaQuery.padding.top : 0;
  final appBarHeight = hasAppBar ? kToolbarHeight : 0;
  final topTotalHeight = statusBarHeight + appBarHeight;
  // 底部高度（安全区域 + TabBar）
  final bottomSafeArea = hasBottomSafeArea ? mediaQuery.padding.bottom : 0;
  final bottomTabBarHeight = hasBottomTabBar ? kBottomNavigationBarHeight : 0;
  final bottomTotalHeight = bottomSafeArea + bottomTabBarHeight;
  // 可用高度
  return screenHeight - topTotalHeight - bottomTotalHeight;
}

/// 设置系统状态栏样式
void setSystemStatusBarStyle ({
  Color? statusBarColor,
  Brightness? statusBarIconBrightness
}) {
  // 设置状态栏颜色
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // 设置状态栏背景色
      statusBarColor: statusBarColor,
      // 设置状态栏图标颜色 (light = 白色图标, dark = 黑色图标)
      statusBarIconBrightness: statusBarIconBrightness,
    ),
  );
}

/// 导航栏主题配置
final appBarTheme = AppBarTheme(
  centerTitle: true,
  backgroundColor: Colors.white,
  titleTextStyle: TextStyle(
    color: const Color(0xFF131313),
    fontSize: adaptFontSize(17),
    fontWeight: FontWeight.w500,
  )
);
/// 底部导航栏主题配置
final bottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: Colors.white,
  selectedItemColor: const Color(0xFF3791FE),
  unselectedItemColor: const Color(0xFFA2A3AC),
  selectedLabelStyle: TextStyle(
    fontSize: adaptFontSize(11),
    color: const Color(0xFF3791FE),
  ),
  unselectedLabelStyle: TextStyle(
    fontSize: adaptFontSize(11),
    color: const Color(0xFFA2A3AC),
  )
);

/// 尺寸适配，方便需要时，统一管理尺寸，尤其需要适配平板时
double adaptSize(double size) => size;
// double adaptSize(double size) => size.w; // ScreenUtilInit
double adaptFontSize(double size) => size;
// double adaptFontSize(double size) => size.sp; // ScreenUtilInit

/// json 解析
Map<String, dynamic> jsonDecodeCustom(String str) => jsonDecode(str);
/// json 编码
String jsonEncodeCustom(Object? object) => jsonEncode(object);
/// json 格式化
String jsonFormat(Object? object) => const JsonEncoder.withIndent('  ').convert(object);

/// 计算文本宽度
double calcTextWidth({
  // 文本
  String? text,
  // 文本样式
  TextStyle? style,
  // 最大宽度
  double? maxWidth,
  // 额外追加高度（用于小调整）
  double extraWidth = 0,
}) {
  final TextPainter textPainter = TextPainter(
    // 设置文本
    text: TextSpan(text: text, style: style),
    // 设置文本方向
    textDirection: TextDirection.ltr,
    // 设置最大宽度进行布局
  )..layout(maxWidth: maxWidth ?? double.infinity);
  // 返回文本的高度
  return textPainter.width + extraWidth;
}

/// 计算文本高度
double calcTextHeight({
  // 文本
  String? text,
  // 文本样式
  TextStyle? style,
  // 最大宽度
  double? maxWidth,
  // 额外追加高度（用于小调整）
  double extraHeight = 0,
  // 最大行数
  int? maxLines
}) {
  final TextPainter textPainter = TextPainter(
    // 设置文本
    text: TextSpan(text: text, style: style),
    // 设置文本方向
    textDirection: TextDirection.ltr,
    // 设置最大行数限制
    maxLines: maxLines,
    // 设置最大宽度进行布局
  )..layout(maxWidth: maxWidth ?? double.infinity);
  // 返回文本的高度
  return textPainter.height + extraHeight;
}

/// 复制内容
Future<void> copy ([String? text]) async {
  await Clipboard.setData(ClipboardData(text: text ?? ''));
}

/// ================================================ 刷新控件配置

/// 刷新头部文案
final WaterDropHeader refreshHeader = getRefreshHeader();
/// 刷新头部文案
WaterDropHeader getRefreshHeader ({
  /// Indicator 颜色
  Color indicatorColor = primaryColor,
  /// Icon 颜色
  Color idleIconColor = Colors.white
}) {
  return WaterDropHeader(
    complete: const SizedBox(),
    completeDuration: const Duration(milliseconds: 100),
    waterDropColor: indicatorColor,
    idleIcon: Icon(
      Icons.autorenew,
      size: 15,
      color: idleIconColor,
    ),
    refresh: SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2.0, color: indicatorColor),
    ),
  );
}

/// 刷新头部文案
// ClassicHeader refreshHeader ({
//   /// Indicator 颜色
//   Color indicatorColor = primaryColor
// }) {
//   return ClassicHeader(
//     idleText: "下拉刷新",
//     releaseText: '释放刷新',
//     refreshingText: "正在刷新...",
//     completeText: "刷新完成",
//     failedText: "刷新失败",
//     completeDuration: const Duration(milliseconds: 100),
//     refreshingIcon: SizedBox(
//       width: 24,
//       height: 24,
//       child: CircularProgressIndicator(strokeWidth: 2.0, color: indicatorColor),
//     ),
//   );
// }

/// 刷新尾部文案
final ClassicFooter refreshFooter = getRefreshFooter();
/// 刷新尾部文案
ClassicFooter getRefreshFooter ({
  /// Indicator 颜色
  Color indicatorColor = primaryColor,
  /// 上拉加载更多
  String? idleText,
  /// 松开加载更多
  String? canLoadingText,
  /// 正在加载更多...
  String? loadingText,
  /// 没有更多数据
  String? noDataText,
}) {
  return ClassicFooter(
    idleText: idleText ?? '上拉加载更多',
    canLoadingText: canLoadingText ?? '松开加载更多',
    loadingText: loadingText ?? '正在加载更多...',
    noDataText: noDataText ?? '没有更多数据',
    completeDuration: const Duration(milliseconds: 100),
    loadingIcon: SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2.0, color: indicatorColor),
    ),
  );
}

/// ================================================ 字符串扩展

/// 字符串扩展
extension StringExtension on String {
  /// 指定每隔每几个字符添加一个空格
  String withSpaces({int groupSize = 4}) {
    String input = this;
    StringBuffer result = StringBuffer();
    // 遍历字符串，按每4位进行分割
    for (int i = 0; i < input.length; i += groupSize) {
      // 获取从当前索引到下一个 groupSize 长度的子字符串
      result.write(input.substring(i, i + groupSize > input.length ? input.length : i + groupSize));
      // 如果当前不是最后一组数字，添加空格
      if (i + groupSize < input.length) {
        result.write(' ');
      }
    }
    return result.toString();
  }
  /// 手机号码脱敏
  String maskPhoneNumber() {
    // 确保手机号长度为11位
    if (length == 11) {
      // 将中间四位替换为星号
      return '${substring(0, 3)}****${substring(7)}';
    }
    // 如果手机号不符合长度要求，直接返回原值
    return this;
  }
}

/// ================================================ 动态生成文件名

/// 生成随机文件名
String generateFileName(String filePath, String dir) {
  // 生成16位随机数
  String randomString = generateRandomString(16);
  // 获取当前时间戳
  String timestamp = date.getCurrentTime(format: 'yyyyMMddHHmmss');
  // 合并随机数和时间戳，生成 MD5
  String toHash = randomString + timestamp;
  // 使用 MD5 对字符串进行加密
  var bytes = utf8.encode(toHash); 
  var md5Hash = md5.convert(bytes).toString();
  // 获取文件后缀名，获取文件的扩展名并去掉'.'
  String fileExtension = p.extension(filePath).replaceAll('.', '');
  // 拼接完整路径
  String filePathWithExtension = '$dir/$md5Hash.$fileExtension';
  // 返回
  return filePathWithExtension;
}

/// 生成指定长度的随机字符串
String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random rand = Random();
  return List.generate(length, (index) => characters[rand.nextInt(characters.length)]).join();
}

/// ================================================ 其它

/// 获取头像
String getAvatarUrl(String? avatar) {
  return getImageUrl(avatar, defaultAvatarUrl);
}

/// 获取图片路径，为空时返回默认
String getImageUrl(String? url, [String? defaultUrl]) {
  return (url ?? '').isNotEmpty ? url! : (defaultUrl ?? '');
}

/// 金额，直接保留两位小数，不足两位补0
String amountAsFixed(double? value, [int? fractionDigits]) {
  return (value ?? 0).toStringAsFixed(fractionDigits ?? 2);
}
/// 分转元，去除末尾多余的0
// String amountAsFixed(double? value, {int fractionDigits = 2}) {
//   final yuan = (value ?? 0) / 100;
//   return yuan.toStringAsFixed(fractionDigits).replaceFirst(RegExp(r'\.?0+$'), '');
// }

// 打开日志
void onOpenLog(BuildContext? context) {
  // 计数
  logs.enableCounter += 1;
  // 检查数量次数是否达到
  if (logs.enableCounter % logs.enableCounterNumber == 0) {
    // 切换开关
    logs.enable(!logs.isEnable, context: context);
  } else {
    // 如果日志开启，并且有上下文，则显示日志按钮，防止兼容问题初始化失败
    if (logs.isEnable && context != null) {
      logs.showButton(context);
    }
  }
}

/// 退出登录
void logoutRequest([VoidCallback? onSuccess]) async {
  try {
    // 阻塞
    hud.show();
    // 请求
    final response = await appRequest.logout();
    // 成功
    if (response.code == 0) {
      hud.showToast('登出成功');
      logout(onSuccess);
    }
  } catch (_) {
    // 隐藏加载提示
    hud.showToast('登出失败');
  }
}

/// 退出登录
void logout([VoidCallback? onSuccess]) {
  // Future.delayed(Duration.zero, () {
  //   accountModel.clear();
  //   storage.remove(PublicKey.modelAccount.value);
  //   nav.offAllNamed(appRoutes.login);
  // });
  accountModel.clear();
  storage.remove(PublicKey.account.value);
  // nav.offAllNamed(appRoutes.initialRoute);
  if (onSuccess != null) { onSuccess(); }
}

/// 注销账号
void deleteAccountRequest([Map<String, dynamic>? parameters]) async {
  try {
    // 阻塞
    hud.show();
    // 请求
    final response = await appRequest.delete(parameters);
    // 成功
    if (response.code == 0) {
      hud.showToast('注销成功');
      logout();
    }
  } catch (_) {
    // 隐藏加载提示
    hud.showToast('注销失败');
  }
}