// import 'package:flutter/material.dart';
import 'package:base_project/base/refresh/index.dart';

class CustomRefreshController extends BaseRefreshController {

  const CustomRefreshController({super.key, required super.title});

  @override
  CustomRefreshControllerState createState() => CustomRefreshControllerState();
}

class CustomRefreshControllerState extends BaseRefreshControllerState {

  // @override
  // Widget? buildAppBar(BuildContext context, String? title) {
  //   return null;
  // }

  @override
  void onRefresh() async {
    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 1));
    // 页面是否还在挂载中
    if (mounted) {
      // 更新数据
      setState(() {
        dataSource = List.generate(20, (index) => "Refreshed Item $index");
        // 打开上拉加载
        enablePullUp = true;
        // 结束加载
        isLoading = false;
      });
      // 结束刷新
      endRefresh(isHasData: dataSource.length < 50);
    }
  }

  @override
  void onLoading() async {
    // 模拟加载更多
    await Future.delayed(const Duration(seconds: 1));
    // 页面是否还在挂载中
    if (mounted) {
      // 更新数据
      setState(() {
        dataSource.addAll(List.generate(10, (index) => "Loaded Item ${dataSource.length + index}"));
      });
      // 结束刷新
      endRefresh(isHasData: dataSource.length < 50);
    }
  }
}
