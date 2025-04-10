import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_project/base/refresh/index.dart';
import 'package:base_project/utils/public.dart';

class CustomNavbarController extends BaseRefreshController {

  const CustomNavbarController({super.key, required super.title});

  @override
  CustomNavbarControllerState createState() => CustomNavbarControllerState();
}

class CustomNavbarControllerState extends BaseRefreshControllerState {

  @override
  // void initState() {
  //   super.initState();
  //   // 使用 WidgetsBinding 来确保页面渲染完成后再主动下拉刷新
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //   // 主动下拉刷新
  //   //   refreshController.requestRefresh();
  //   // });
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
      });
      // 结束刷新
      refreshController.refreshCompleted();
      // 解除没有更多数据
      refreshController.resetNoData();
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
      if (dataSource.length >= 50) {
        // 没有更多数据
        refreshController.loadNoData();
      } else {
        // 结束刷新
        refreshController.loadComplete();
      }
    }
  }

  @override
  Widget? buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: dataSource.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(dataSource[index]));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取状态栏的高度
    double statusBarHeight = getStatusBarHeight(context);
    // 页面渲染
    return Scaffold(
      body: Column(
        children: [
          // 自定义导航条
          Container(
            height: statusBarHeight + navBarHeight, // 结合状态栏和自定义导航条的高度
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.only(top: statusBarHeight), // 确保标题不会被状态栏遮挡
              child: Stack(
                children: [
                  // const SizedBox(width: 10), // 添加间距
                  Container(
                    color: Colors.blue,  // 设置背景颜色
                    child: const Center(
                      child: Text(
                        'Custom Title',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: adaptSize(10),
                    height: navBarHeight,
                    child: Container(
                      color: Colors.red,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // 返回上一页
                        },
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading,
              header: refreshHeader,
              footer: refreshFooter,
              enablePullDown: enablePullDown,
              enablePullUp:  enablePullUp,
              child: buildBody(context),
            ),
          )
        ],
      )
    );
  }
}
