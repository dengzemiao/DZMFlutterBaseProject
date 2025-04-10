import 'package:flutter/material.dart';
// import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';
import 'package:base_project/components/app_bar.dart';

@immutable
class BaseStatelessController extends StatelessWidget {

  /// 导航标题
  final String? title;
  /// 背景颜色
  final Color? backgroundColor = primaryBgColor;

  const BaseStatelessController({super.key, this.title});
  
  /// 渲染 AppBar
  Widget? buildAppBar (BuildContext context, String? title) {
    return (
      title != null 
      ?
      CustomAppBar(title: title)
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
    return Center(child: Text(title ?? 'BaseStatelessController'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 自定义导航栏
          buildAppBar(context, title) ?? Container(),
          // 页面内容
          Expanded(
            child: buildBodyBackground(context) ?? Container(),
          )
        ]
      ),
    );
  }
}