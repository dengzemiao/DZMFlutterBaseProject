import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';

class BaseScrollController extends BaseStatefulController {
  
  const BaseScrollController({super.key, super.title});

  @override
  BaseScrollControllerState createState() => BaseScrollControllerState();
}

class BaseScrollControllerState extends BaseStatefulControllerState {
  
  /// 是否禁用回弹
  bool isBounces = false;

  @override
  Widget? buildBody(BuildContext context) {
    return buildScrollView(context);
  }

  /// 构建 ScrollView
  Widget? buildScrollView(BuildContext context) {
    return SingleChildScrollView(
      // 禁用回弹效果
      physics: isBounces ? const ClampingScrollPhysics() : null,
      child: buildScrollViewChild(context),
    );
  }

  /// 构建 ScrollView Child
  Widget? buildScrollViewChild (BuildContext context) {
    return Center(child: Text(widget.title ?? 'BaseScrollController'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 禁用自动调整
      resizeToAvoidBottomInset: false,
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