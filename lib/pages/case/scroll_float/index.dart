import 'package:flutter/material.dart';
import 'package:base_project/base/refresh/index.dart';
// import 'package:base_project/utils/public.dart';

class ScrollFloatController extends BaseRefreshController {

  const ScrollFloatController({super.key, super.title});

  @override
  ScrollFloatControllerState createState() => ScrollFloatControllerState();
}

class ScrollFloatControllerState extends BaseRefreshControllerState {

  @override
  Widget? buildListView(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // SliverAppBar
        // 作用: 用于实现可滚动的应用栏。通常与 CustomScrollView 一起使用，并允许你设置折叠效果、背景图片等。
        // expandedHeight: 设置展开时的最大高度。
        // pinned: 设置为 true 时，应用栏会固定在顶部。
        // floating: 设置为 true 时，应用栏会在滚动过程中立即显示出来。
        // flexibleSpace: 定义一个可以动态变换的空间，通常用于放置背景图和标题。
        // SliverAppBar(
        //   expandedHeight: 200.0,
        //   floating: true,
        //   pinned: true,
        //   flexibleSpace: FlexibleSpaceBar(
        //     title: const Text('SliverAppBar', style: TextStyle(color: Colors.white),),
        //     background: Image.asset('assets/images/a_temp.png', fit: BoxFit.cover)
        //   ),
        // ),
        

        // SliverToBoxAdapter
        // 作用: 用于将普通的非滚动内容（如 Container、Text 等）嵌入到 CustomScrollView 中，提供了与 Sliver 组件的兼容性。
        // child: 容器中的普通小部件，可以是任何不支持滚动的视图。
        SliverToBoxAdapter(
          child: Container(
            color: Colors.blue,
            height: 100.0,
            child: const Center(child: Text('Static content')),
          ),
        ),

        // SliverPersistentHeader
        // 作用: 用于创建一个在滚动过程中保持固定或者可以滑动的头部。它常用于实现可伸缩的头部，通常会和 SliverAppBar 结合使用。
        // delegate: 用于自定义头部的布局和行为。你可以通过实现 SliverPersistentHeaderDelegate 来定义一个自定义的头部组件。
        SliverPersistentHeader(
          // 保持在顶部
          pinned: true,
          // 悬浮内容
          delegate: MySliverHeaderDelegate(
            // // 传递点击事件回调
            onTap: () {
              // print('点击事件回调');
              setState(() {
                dataSource = [];
              });
              // 下拉刷新
              onRefresh();
            }
          )
        ),
        
        // SliverGrid
        // 作用: 用于显示一个网格布局，可以指定每行的列数或者其他网格布局方式。
        // 作用: 用于显示一个垂直方向的滚动列表。通常用 SliverChildBuilderDelegate 或 SliverChildListDelegate 来提供列表项。
        // gridDelegate: 用于定义网格的布局方式，如 SliverGridDelegateWithFixedCrossAxisCount（固定列数）或 SliverGridDelegateWithMaxCrossAxisExtent（最大列宽）。
        // delegate: 用于构建每一项内容。
        SliverPadding(
          // 需要间距用这个
          padding: const EdgeInsets.all(20.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // 每行显示几个
              crossAxisCount: 3,
              // 横向间距
              crossAxisSpacing: 8.0,
              // 纵向间距
              mainAxisSpacing: 16.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Card 自带周边间距，根据情况选择
                return Card(
                  child: Center(child: Text('Item $index')),
                );
              },
              childCount: 5,
            ),
          ),
        ),

        // SliverList
        // 作用: 用于显示一个垂直方向的滚动列表。通常用 SliverChildBuilderDelegate 或 SliverChildListDelegate 来提供列表项。
        // delegate: SliverChildBuilderDelegate 或 SliverChildListDelegate，用于构建每一项内容。
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(title: Text('Item $index'));
            },
            childCount: dataSource.length,
          ),
        ),

        // SliverFillRemaining
        // 作用: 用于填充剩余的空间，使得它可以占据父容器剩余的滚动区域。这非常适合一些需要占据剩余空间的内容，比如页脚。
        // hasScrollBody: 设置为 false 时，表示剩余空间不会滚动，适合用作固定页脚。
        // child: 子部件，通常是填充整个屏幕的内容。
        // const SliverFillRemaining(
        //   hasScrollBody: false,
        //   child: Center(child: Text('Footer Content')),
        // )
      ],
    );
  }
  
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text(widget.title!)),
  //     body: 
  //   );
  // }
}

// SliverPersistentHeaderDelegate
class MySliverHeaderDelegate extends SliverPersistentHeaderDelegate {

  final VoidCallback onTap;

  MySliverHeaderDelegate({required this.onTap});

  @override
  double get maxExtent => 200.0;
  @override
  double get minExtent => 50.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return InkWell(
      onTap: onTap, // 添加点击事件
      child: Container(
        color: Colors.orange,
        alignment: Alignment.center,
        child: const Center(child: Text('Custom Header'))
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

