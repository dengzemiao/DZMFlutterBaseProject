import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';
import './ud_refresh/index.dart';
import './ui_base/index.dart';
import './request/index.dart';
import './scroll_float/index.dart';
import './custom_navbar/index.dart';
import './load_image/index.dart';
import './animated/index.dart';
import './alert/index.dart';
import './countdown/index.dart';

class CaseController extends BaseStatefulController {

  const CaseController({super.key});

  @override
  CaseControllerState createState() => CaseControllerState();
}

class CaseControllerState extends BaseStatefulControllerState {

  /// 案例列表
  final List<Map<String, dynamic>> caseList = [
    {
      'title': '基础布局展示',
      'route': const UiBaseController(title: '基础布局')
    },
    {
      'title': '上下拉加载刷新',
      'route': const CustomRefreshController(title: '上下拉加载')
    },
    {
      'title': '滚动悬浮',
      'route': const ScrollFloatController(title: '滚动悬浮')
    },
    {
      'title': '动画展示',
      'route': const AnimateController(title: '动画展示')
    },
    {
      'title': '自定义导航条',
      'route': const CustomNavbarController(title: '自定义导航条')
    },
    {
      'title': '网络接口请求',
      'route': const RequestController(title: '接口请求')
    },
    {
      'title': '网络图片加载（包含本地图片）',
      'route': const LoadImageController(title: '图片加载')
    },
    {
      'title': 'Alert 提示',
      'route': const AlertController(title: 'Alert 提示')
    },
    {
      'title': '倒计时',
      'route': const CountdownController(title: '倒计时')
    }
  ];

  @override
  Widget? buildAppBar(BuildContext context, String? title) {
    return super.buildAppBar(context, 'Case');
  }

  // 退出登录
  void onLogout() {
    storage.remove(PublicKey.account.value);
    nav.offAllNamed(appRoutes.initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case')),
      body: SizedBox(
        width: double.infinity,
        child: ListView.separated(
          itemCount: caseList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(caseList[index]['title']),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => caseList[index]['route']));
              }
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onLogout,
        child: const Icon(Icons.exit_to_app)
      )
    );
  }
}