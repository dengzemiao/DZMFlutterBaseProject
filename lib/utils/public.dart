import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:jiffy/jiffy.dart';
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
/// 接口调试类型 0: 系统环境, 1: 测试环境, 2: 正式环境
int debugType = 0;
/// 默认头像
String defaultAvatarUrl = 'assets/images/image_avatar.png';

/// ================================================ 公共系统函数

/// 初始化
void initPub() {
}

/// DeepLinks 处理，例如 dengzemiao:///pages/player?id=123
void deepLinksHandle(Uri? link) {
  // 有值
  if (link != null) {
    // 输出
    // log(link.path);
    // log(link.queryParameters);
    // 日志路径
    if (link.path == appRoutes.logvc) {
      // 打开/关闭日志
      if (link.queryParameters.containsKey('open')) {
        final openLog = link.queryParameters['open'];
        logs.enable(openLog == '1' || openLog == 'true');
      }
      // 跳转页面
      nav.toNamed(link.path, parameters: link.queryParameters);
    }
  }
}

/// App 是否进行更新
void initAppUpdate(BuildContext context) async {
  // 检查是否需要更新
  try {
    // 获取包信息
    final packageInfo = await PackageInfo.fromPlatform();
    // 发起网络请求
    final params = {
      'current_version': packageInfo.version,
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
      if (Version.parse(appUpdateModel.latestVersion ?? '1.0.0') > Version.parse(packageInfo.version)) {
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

/// 判断是否为线上环境
// kDebugMode: 为 true 时表示处于 调试模式。
// kReleaseMode: 为 true 时表示处于 发布模式。
// kProfileMode: 为 true 时表示处于 性能分析模式。
bool isDebug() {
  // 判断调试类型
  if (debugType == 1) {
    // 测试环境
    return true;
  } else if (debugType == 2) {
    // 开发环境
    return false;
  }
  // 系统环境
  return !kReleaseMode;
}
/// 状态栏高度
double getStatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}
/// 底部安全区域高度
double getBottomSafeAreaHeight(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
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

/// ================================================ 时间戳处理

/// 判断指定时间戳是否超过今天，并指定超过多少天
bool isTimestampOverDays(int timestamp, int days) {
  // 获取当前时间的秒级时间戳
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  // 计算时间差（单位：秒）
  int difference = currentTimestamp - timestamp;
  // 判断时间差是否超过指定天的秒数
  return difference > (days * 24 * 60 * 60);
}

/// 格式化时间戳（秒）
String formatTimestamp(int? timestamp,  {bool showHours = true}) {
  return formatDuration(Duration(seconds: timestamp ?? 0), showHours: showHours);
}

/// 格式化时间为 `00:00:00` 或者 `00:00`
String formatDuration (Duration? duration, {bool showHours = true}) {
  // 确保有值
  final temp = duration ?? Duration.zero;
  // 格式
  if (showHours) {
    // 显示为 `00:00:00`
    return '${temp.inHours.toString().padLeft(2, '0')}:${(temp.inMinutes % 60).toString().padLeft(2, '0')}:${(temp.inSeconds % 60).toString().padLeft(2, '0')}';
  } else {
    // 显示为 `00:00`
    return '${(temp.inMinutes % 60).toString().padLeft(2, '0')}:${(temp.inSeconds % 60).toString().padLeft(2, '0')}';
  }
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
  Color indicatorColor = primaryColor
}) {
  return ClassicFooter(
    idleText: "上拉加载更多",
    canLoadingText: '松开加载更多',
    loadingText: "正在加载更多...",
    noDataText: '没有更多数据',
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
  // 获取当前时间戳（使用 Jiffy）
  String timestamp = Jiffy.now().format(pattern: 'yyyyMMddHHmmss');
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

/// 金额
String amountAsFixed(double? value, [int? fractionDigits]) {
  return (value ?? 0).toStringAsFixed(fractionDigits ?? 2);
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