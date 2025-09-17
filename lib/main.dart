import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_project/utils/public.dart';
// import 'package:base_project/utils/navigator_observer.dart';
import 'package:base_project/utils/constant.dart';
import 'package:get/get.dart';

void main() {
  
  // 确保绑定已初始化
  WidgetsFlutterBinding.ensureInitialized(); 

  // 初始化设备工具类
  device.init();
  // 根据设备类型设置屏幕方向
  if (device.isTablet) {
    // 平板模式：支持所有方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // 手机模式：只支持竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // 不登录也能使用 App 走这种方式
  // runApp(const MyApp());

  // 必须登录才能使用 App 走这种方式
  runApp(
    FutureBuilder<dynamic>(
      // 同步数据
      future: Future.wait([
        // 获取账户信息
        storage.getStringPro(PublicKey.account.value, defaultValue: '{}'),
        // 获取是否是调试模式
        storage.getBool(PublicKey.debugMode.value, defaultValue: kDebugMode),
        // 获取包信息
        PackageInfo.fromPlatform(),
        // 获取日志状态
        logs.sync(),
      ]),
      // 构建
      builder: (context, snapshot) {
        // 等待数据
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 在加载过程中显示一个进度条
          return const MaterialApp(home: Center(child: CircularProgressIndicator()));
        }
        // 获取数据更新账户信息
        accountModel.updateFromRawJson(snapshot.data[0]);
        // 获取是否是调试模式
        isDebugMode ??= snapshot.data[1];
        // 获取包信息
        packageInfo ??= snapshot.data[2];
        // // 是否有 token
        // if (accountModel.accessToken != null && accountModel.accessToken!.isNotEmpty) {
        //   // 有 token 跳转到 tabbar 页面
        //   return MyApp(initialRoute: appRoutes.tabbar, initialRoutePage: appRoutes.tabbarPage);
        // } else {
        //   // 没有 token 跳转到 login 页面
        //   return MyApp(initialRoute: appRoutes.login, initialRoutePage: appRoutes.logPage);
        // }
        // 审核要求，必须要用户能看到内容
        return MyApp(initialRoute: appRoutes.tabbar, initialRoutePage: appRoutes.initialRoutePage);
      },
    )
  );
}

class MyApp extends StatefulWidget {

  /// 默认路由
  final String initialRoute;
  final Widget initialRoutePage;

  const MyApp({
    super.key,
    required this.initialRoute,
    required this.initialRoutePage,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  /// AppLinks
  late AppLinks _appLinks;
  /// 监听对象
  StreamSubscription<Uri>? _linkSubscription;
  
  @override
  void initState() {
    super.initState();
    // 添加日志
    logs.add({logs.keyTitle: '当前环境：${isDebugMode! ? '测试' : '正式'}', logs.keyData: {'isDebugMode': isDebugMode}});
    // 初始化网络状态
    network.initialize();
    // 初始化 DeepLinks 监听
    initDeepLinks();
    // 注册生命周期监听
    // WidgetsBinding.instance.addObserver(this);
    // 添加一次性监听，网络连接成功时，会调用此方法
    network.addOneTimeListener(({required results, required isConnected}) {
      if (isConnected) {
        // 操作当前页面的网络数据
        initOnConnectivitySuccess();
      }
    });
  }

  @override
  void dispose() {
    // 取消网络状态监听
    network.dispose();
    // 取消 DeepLinks 监听
    _linkSubscription?.cancel();
    // 移除生命周期监听
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  /// 初始化网络授权成功回调
  void initOnConnectivitySuccess () {
  }

  /// 初始化 DeepLinks 监听，例如现有 URL Scheme 配置路径：aixuetang:///pay?id=123
  void initDeepLinks() async {
    try {
      _appLinks = AppLinks();
      // 获取启动时的链接
      _appLinks.getInitialLink().then((link) {
        // 日志记录
        logs.add({logs.keyTitle: 'DeepLinks - 启动链接 - ${link != null ? '有值' : '无值'}', logs.keyData: {
          'link': link.toString(),
          'path': link?.path,
          'host': link?.host,
          'scheme': link?.scheme,
          'fragment': link?.fragment,
          'pathSegments': link?.pathSegments,
          'queryParameters': link?.queryParameters,
        }});
        // 如果有值，处理启动时接收到的链接
        if (link != null) {
          deepLinksHandle(link);
        }
      });
      // 监听链接变化，应用在运行时接收到的链接，或每当应用通过深度链接被唤醒时，都会触发该方法
      _linkSubscription = _appLinks.uriLinkStream.listen((link) {
        // 日志记录
        logs.add({logs.keyTitle: 'DeepLinks -唤醒链接 - 有值', logs.keyData: {
          'link': link.toString(),
          'path': link.path,
          'host': link.host,
          'scheme': link.scheme,
          'fragment': link.fragment,
          'pathSegments': link.pathSegments,
          'queryParameters': link.queryParameters,
        }});
        // 处理链接
        deepLinksHandle(link);
      });
    } catch (e, stackTrace) {
      logs.add({logs.keyTitle: 'DeepLinks - 报错', logs.keySuccess: false, logs.keyData: {
        'error': e.toString(),
        'stackTrace': stackTrace.toString(),
      }});
    }
  }

  // // 监听生命周期状态的变化
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       logs.add({logs.keyTitle: '应用进入前台'});
  //       break;
  //     case AppLifecycleState.inactive:
  //       logs.add({logs.keyTitle: '应用处于非活动状态'});
  //       break;
  //     case AppLifecycleState.paused:
  //       logs.add({logs.keyTitle: '应用进入后台'});
  //       break;
  //     case AppLifecycleState.detached:
  //       logs.add({logs.keyTitle: '应用被销毁或分离'});
  //       break;
  //     case AppLifecycleState.hidden:
  //       logs.add({logs.keyTitle: '应用进入视图隐藏状态'});
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    // 个人觉得 ScreenUtilInit 这个库可使用可不使用，不使用也没什么问题
    // 个人倾向于不使用，这样横屏或者ipad上好适配，如果需要使用推荐宽高都采用 .w 的方式，并打开注释
    // return ScreenUtilInit(
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //   designSize: const Size(375, 812),
    //   builder: (context, child) => buildMaterialApp(context)
    // );

    // return PopScope(
    //   // 允许物理返回键
    //   canPop: false,
    //   // 回调
    //   onPopInvokedWithResult: (didPop, result) {
    //     if (didPop) {
    //       // 进入后台
    //       SystemNavigator.pop();
    //     }
    //   },
    //   child: buildMaterialApp(context);
    // );

    // 屏幕方向回调
    // return OrientationBuilder(
    //   builder: (context, orientation) {
    //     // 获取屏幕尺寸
    //     final screenSize = MediaQuery.of(context).size;
    //     // 平板模式
    //     if (device.isTablet) {
    //       // 平板模式
    //       return Container(
    //         color: const Color(0xFFE6E6E6),
    //         child: Center(
    //           child: SizedBox(
    //             width: screenSize.width,
    //             height: screenSize.height,
    //             child: buildMaterialApp(context),
    //           ),
    //         ),
    //       );
    //     } else {
    //       // 手机模式
    //       return buildMaterialApp(context);
    //     }
    //   },
    // );
    
    // 构建
    return buildMaterialApp(context);
  }

  /// MaterialApp
  Widget buildMaterialApp(BuildContext context) {
    return GetMaterialApp(
      title: '水哥自用框架',
      // 路由观察者，目前 PublicNavigatorObserver() 的功能已经可以放到 routeObserver 回调中去实现了。
      // navigatorObservers: [PublicNavigatorObserver(), routeObserver],
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        // 全局去掉水波纹
        splashColor: Colors.transparent,
        // 全局去掉点击时的高亮
        highlightColor: Colors.transparent,
        // 全局去掉获得焦点时的高亮
        focusColor: Colors.transparent,
        // 全局去掉鼠标悬停时的高亮
        hoverColor: Colors.transparent,
        // 背景颜色，这个放到单页面设置了
        // scaffoldBackgroundColor: Colors.white,
        // 导航栏配置，这个放到自定义导航栏里设置了
        // appBarTheme: appBarTheme,
        // Tabbar 配置
        bottomNavigationBarTheme: bottomNavigationBarTheme
      ),
      // 设置应用语言为中文
      locale: const Locale('zh', 'CN'),
      // 本地化代理
      localizationsDelegates: const [
        // 提供 Material 组件的中文文本
        GlobalMaterialLocalizations.delegate,
        // 提供 Widget 的中文文本
        GlobalWidgetsLocalizations.delegate,
        // 提供 Cupertino 组件的中文文本
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // 中文
        Locale('zh', 'CN'),
      ],
      defaultTransition: Transition.cupertino,
      builder: hud.init(),
      // initialBinding: InitBinding(),
      // 初始路由会被 InitBinding 覆盖
      initialRoute: widget.initialRoute,
      getPages: appRoutes.getPages,
      unknownRoute: GetPage(name: appRoutes.initialRoute, page: () => widget.initialRoutePage),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() async {
    // // 放在这里，启动时会闪动
    // // 获取 token
    // final token = await storage.getStringPro(PublicKey.token.value);
    // // 是否有登录
    // if (token.isNotEmpty) {
    //   // 有登录
    //   nav.offAllNamed(appRoutes.tabbar);
    // } else {
    //   // 没有登录
    //   nav.offAllNamed(appRoutes.login);
    // }
  }
}