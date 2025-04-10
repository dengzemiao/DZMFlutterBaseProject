import 'package:base_project/utils/public.dart';
import 'package:flutter/material.dart';
// import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';
import 'package:base_project/components/app_bar.dart';

@immutable
class BaseStatefulController extends StatefulWidget {

  /// 导航标题
  final String? title;

  const BaseStatefulController({super.key, this.title});

  @override
  State<BaseStatefulController> createState() => BaseStatefulControllerState();
}

class BaseStatefulControllerState extends State<BaseStatefulController> with RouteAware {

  /// 启用路由观察者
  bool enableRouteObserver = false;
  /// 加载状态
  bool isLoading = false; 
  /// 背景颜色
  Color? backgroundColor = primaryBgColor;

  @override
  void initState() {
    super.initState();
    // 等待加载
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 初始化上下文完成
      initStateContext();
    });
  }

  /// 初始化上下文完成，可以在这里做一些需要上下文的初始化操作
  void initStateContext () {
    // 添加日志按钮
    logs.showButton(context);
    // 注册路由监听
    if (enableRouteObserver) {
      final route = ModalRoute.of(context);
      if (route is PageRoute) {
        routeObserver.subscribe(this, route);
      }
    }
  }

  @override
  void dispose() {
    // 取消路由监听
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // log("页面被 push 到栈顶，页面可见");
  }
  @override
  void didPop() {
    // log("页面被 pop，页面销毁");
  }
  @override
  void didPushNext() {
    // log("有新页面 push 进来，当前页面进入不可见状态");
  }
  @override
  void didPopNext() {
    // log("上一个页面被 pop，当前页面重新可见");
  }

  /// 返回事件
  void onBack() {
    nav.back();
  }

  /// 渲染 AppBar
  Widget? buildAppBar (BuildContext context, String? title) {
    return (
      title != null 
      ?
      CustomAppBar(title: title, onLeftCallback: onBack)
      :
      null
    );
  }

  /// 渲染 Body 背景
  Widget? buildBodyBackground(BuildContext context) {
    return buildBody(context);
  }

  /// 渲染 Body
  Widget? buildBody(BuildContext context) {
    return Center(child: Text(widget.title ?? 'BaseStatefulController'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 自定义导航栏
          buildAppBar(context, widget.title) ?? Container(),
          // 页面内容
          Expanded(
            child: buildBodyBackground(context) ?? Container(),
          )
        ]
      ),
    );
  }
}