import 'package:base_project/utils/public.dart';
import 'package:flutter/material.dart';
import '../home/index.dart';
import '../my/index.dart';
import '../case/index.dart';
// import 'package:base_project/pages/my/user_info.dart';

class TabbarController extends StatefulWidget {

  const TabbarController({ super.key });

  @override
  State<StatefulWidget> createState() {
    return _TabbarControllerState();
  }
}

class _TabbarControllerState extends State<TabbarController> {

  /// 当前选中的索引
  int _currentIndex = 0;
  /// Tabbar 页面列表
  late List<Widget> _pages;
  /// 使用 GlobalKey 绑定 UserController 状态
  final GlobalKey<UserControllerState> _userKey = GlobalKey<UserControllerState>();
  /// Items
  final List<Map<String, String>> _items = [
    {
      'icon': 'assets/images/tabbar_normal_1.png',
      'activeIcon': 'assets/images/tabbar_select_1.png',
      'label': '案例'
    },
    {
      'icon': 'assets/images/tabbar_normal_0.png',
      'activeIcon': 'assets/images/tabbar_select_0.png',
      'label': '首页'
    },
    {
      'icon': 'assets/images/tabbar_normal_2.png',
      'activeIcon': 'assets/images/tabbar_select_2.png',
      'label': '我的'
    },
  ];

  @override
  void initState() {
    super.initState();
    // 初始化
    _pages = [
      // const UserInfoController(title: ''), // 用于写静态页面或对接接口快捷调试
      const CaseController(),
      const HomeController(),
      UserController(key: _userKey, title: '我的'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 顶部导航条
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      // ),
      // 显示当前页面
      body: IndexedStack(
        index: _currentIndex,
        children: _pages
      ),
      // 底部 Tabbar
      bottomNavigationBar: BottomNavigationBar(
        // 类型
        type: BottomNavigationBarType.fixed,
        // 当前选中索引
        currentIndex: _currentIndex,
        // 点击切换
        onTap: (index) {
          setState(() {
            // (2：我的) && 没有 token
            // if ([2].contains(index) && accountModel.accessToken == null) {
            //   // 跳转到登录页面
            //   nav.toNamed(appRoutes.login);
            //   return;
            // }
            // 更新索引
            _currentIndex = index;
            // 换到 MyController 时触发刷新
            if (_currentIndex == 2) {
              // 有登录获取数据
              if (accountModel.accessToken != null && accountModel.accessToken!.isNotEmpty) {
                // 同步个人信息
                // _userKey.currentState?.getUserInfo();
              }
            }
          });
        },
        // 底部 Tabbar 按钮
        // items: const [
        //   BottomNavigationBarItem(icon: Icon(Icons.star_rate), label: 'Case'),
        //   BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //   BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        // ],
        items: _items.map((item) => BottomNavigationBarItem(
          icon: Image.asset(item['icon']!, width: 24.0, height: 24.0),
          activeIcon: Image.asset(item['activeIcon']!, width: 24.0, height: 24.0),
          label: item['label']
        )).toList(),
        // 选中项颜色（文字 + 图标）
        selectedItemColor: Colors.red,
        // 未选中项颜色（文字 + 图标）
        unselectedItemColor: Colors.yellow,
        // 选中项文字样式
        // selectedLabelStyle: const TextStyle(fontSize: 12.0),
        // 未选中项文字样式
        // unselectedLabelStyle: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}
