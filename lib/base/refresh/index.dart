import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/components/empty_view.dart';
import '../stateful/index.dart';

@immutable
class BaseRefreshController extends BaseStatefulController {

  const BaseRefreshController({super.key, super.title});

  @override
  BaseRefreshControllerState createState() => BaseRefreshControllerState();
}

class BaseRefreshControllerState extends BaseStatefulControllerState {

  /// 请求会话ID（用于请求分页数据使用，服务器返回 -1 则表示没有更多数据了）
  int requestId = 0;
  /// 请求数量
  int pageSize = 20;
  /// 是否禁用回弹
  bool isBounces = false;
  /// 初始化自动下拉刷新
  bool initialRefresh = true;
  /// 是否启用下拉刷新（重置数据）
  bool enablePullDown = true;
  /// 是否启用上拉刷新（加载更多）
  bool enablePullUp = false;
  /// 显示空数据页面
  bool isShowEmpty = false;
  /// 空数据页面支持上下拉加载
  bool isShowEmptyAllowRefresh = false;
  /// 数据列表
  List<dynamic> dataSource = [];
  // List<String> items = List.generate(20, (index) => 'Item $index');
  /// 刷新控制器
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    // 初始化刷新控制器
    initRefreshController();
  }

  /// 初始化刷新控制器
  void initRefreshController () {
    // 开启了显示空数据视图
    if (isShowEmpty) {
      setState(() { isLoading = initialRefresh; });
    }
    // 初始化
    refreshController = RefreshController(initialRefresh: initialRefresh);
  }
  
  /// 下拉刷新
  void onRefresh() async {
    // 获取列表数据
    getList(false);

    // // 关闭上拉加载
    // setState(() {
    //   enablePullUp = false;
    // });
    // // 模拟网络请求
    // await Future.delayed(const Duration(seconds: 1));
    // // 页面是否还在挂载中
    // if (mounted) {
    //   // 更新数据
    //   setState(() {
    //     dataSource = List.generate(20, (index) => "Refreshed Item $index");
    //     // 打开上拉加载
    //     enablePullUp = true;
    //     // 结束加载
    //     isLoading = false;
    //   });
    //   // 结束刷新 - 分开写
    //   // // 结束下拉刷新
    //   // refreshController.refreshCompleted();
    //   // // 解除没有更多数据
    //   // refreshController.resetNoData();
    //   // 结束刷新 - 合并写
    //   endRefresh(isHasData: dataSource.length < 50);
    // }
  }

  /// 上拉刷新
  void onLoading() async {
    // 获取列表数据
    getList(true);

    // // 模拟加载更多
    // await Future.delayed(const Duration(seconds: 1));
    // // 页面是否还在挂载中
    // if (mounted) {
    //   // 更新数据
    //   setState(() {
    //     dataSource.addAll(List.generate(10, (index) => "Loaded Item ${dataSource.length + index}"));
    //   });
    //   // 结束刷新 - 分开写
    //   // if (dataSource.length >= 50) {
    //   //   // 没有更多数据
    //   //   refreshController.loadNoData();
    //   // } else {
    //   //   // 结束上拉刷新
    //   //   refreshController.loadComplete();
    //   // }
    //   // 结束刷新 - 合并写
    //   endRefresh(isHasData: dataSource.length < 50);
    // }
  }

  // 获取列表数据
  void getList (bool isMore) async {
    // 下拉刷新
    if (!isMore) {
      // 关闭上拉加载
      closePullUp();
    }
    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 1));
    // 页面是否还在挂载中
    if (mounted) {
      // 组装数据推荐放到外面，先组装，setState 中只需要直接赋值更新即可，现在是案例所以在 setState 里面组装了
      // 更新数据
      setState(() {
        // 追加数据
        if (isMore) {
          dataSource.addAll(
            List.generate(10, (index) => "Loaded Item ${dataSource.length + index}")
          );
        } else {
          // 初始化列表
          dataSource = List.generate(20, (index) => "Refreshed Item $index");
          // 根据情况打开上拉加载
          openPullUp();
        }
      });
      // 结束刷新 - 合并写
      endRefresh(isHasData: dataSource.length < 50);
    }
  }

  /// 打开上拉加载
  void openPullUp () {
    Future.microtask(() {
      setState(() {
        // 是否显示空数据（在开启空数据展示的情况下可以避免初始化就显示，其他情况可以任意使用 isLoading）
        if (isShowEmpty) {
          // 没数据则不打开上拉加载，有数据则打开
          enablePullUp = dataSource.isNotEmpty;
          // 关闭加载
          isLoading = false;
        } else {
          // 打开上拉加载
          enablePullUp = true;
        }
      });
    });
  }

  /// 关闭上拉加载
  void closePullUp () {
    Future.microtask(() {
      setState(() {
        enablePullUp = false;
      });
    });
  }

  /// 结束刷新 isPull: 是否下拉 isHasData: 有更多数据
  void endRefresh ({bool? isPull, bool? isHasData}) {
    // 是否为空
    if (isPull == null) {
        // 结束下拉刷新
        refreshController.refreshCompleted();
        // 结束上拉刷新
        refreshController.loadComplete();
    } else {
      if (isPull) {
        // 结束下拉刷新
        refreshController.refreshCompleted();
      } else {
        // 结束上拉刷新
        refreshController.loadComplete();
      }
    }
    // 是否为空
    if (isHasData != null) {
      // 解除没有更多数据
      if (isHasData) {
        // 解除没有更多数据
        refreshController.resetNoData();
      } else {
        // 没有更多数据
        refreshController.loadNoData();
      }
    }
  }

  @override
  Widget? buildBody(BuildContext context) {
    // 构建 下拉刷新控制器
    // return buildRefresh();
    // 根据条件展示
    return buildBodyColumn(context, isShowEmpty);
  }

  Widget? buildBodyColumn (BuildContext context, bool isShowEmpty) {
    return Column(
      children: [
        // 构建 头部工具栏
        buildBodyHeader(context) ?? const SizedBox(),
        // 构建 列表
        Expanded(
          child: isShowEmpty && !isShowEmptyAllowRefresh && !isLoading && dataSource.isEmpty
          ?
          buildEmptyView(context) ?? const SizedBox()
          :
          buildRefresh(context) ?? const SizedBox()
        )
      ]
    );
  }

  /// 构建 头部工具栏
  Widget? buildBodyHeader (BuildContext context) {
    return Container(
      height: getStatusBarHeight(context) + navBarHeight,
      color: Colors.pink,
      child: Center(
        child: Text('固定头部工具栏', style: TextStyle(color: Colors.white, fontSize: adaptFontSize(24)))
      ),
    );
  }

  /// 构建 下拉刷新控制器
  Widget? buildRefresh (BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: buildRefreshHeader(),
      footer: buildRefreshFooter(),
      enablePullDown: enablePullDown,
      enablePullUp:  enablePullUp,
      child: isShowEmpty && isShowEmptyAllowRefresh && !isLoading && dataSource.isEmpty
      ?
      buildEmptyView(context) ?? const SizedBox()
      :
      buildRefreshChild(context) ?? const SizedBox()
    );
  }

  /// 构建 刷新控制器头部
  Widget? buildRefreshHeader () {
    return refreshHeader;
  }

  /// 构建 刷新控制器尾部
  Widget? buildRefreshFooter () {
    return refreshFooter;
  }

  /// 构建 刷新控制器子页面
  Widget? buildRefreshChild (BuildContext context) {
    // 直接返回列表
    return buildListView(context);
  }

  /// 构建 空数据页
  Widget? buildEmptyView (BuildContext context) {
    // return const Center(child: Text('暂无数据'));
    return const EmptyView(
      imageUrl: 'assets/images/image_empty_0.png',
      title: '暂无数据',
    );
  }

  /// 构建 ListView
  Widget? buildListView(BuildContext context) {
    return ListView.builder(
      // 禁用回弹效果
      physics: isBounces ? const ClampingScrollPhysics() : null,
      itemCount: dataSource.length,
      itemBuilder: (context, index) {
        return buildListViewItem(context, index);
      }
    );
  }

  /// 构建 ListViewItem
  Widget? buildListViewItem(BuildContext context, int index) {
    return ListTile(key: ValueKey(index), title: Text(dataSource[index]));
  }

}