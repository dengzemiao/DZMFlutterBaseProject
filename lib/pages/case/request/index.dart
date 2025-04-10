import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:base_project/utils/public.dart';

class RequestController extends BaseStatefulController {

  const RequestController({super.key, super.title});

  @override
  RequestControllerState createState() => RequestControllerState();
}

class RequestControllerState extends BaseStatefulControllerState {

  @override
  void initState() {
    super.initState();
  }

  // 带图提示框
  void onGetRequest1() {

    // 文案提示
    // hud.showToast(
    //   '加载完成', 
    //   duration: const Duration(seconds: 2),
    // );

    // 带图文案提示
    EasyLoading().radius = 10;
    // EasyLoading().indicatorType = EasyLoadingIndicatorType.fadingGrid;
    EasyLoading().loadingStyle = EasyLoadingStyle.custom;
    EasyLoading().textColor = Colors.white;
    EasyLoading().maskColor = Colors.red.withOpacity(0.5);
    EasyLoading().indicatorColor = Colors.green.withOpacity(0.5);
    EasyLoading().progressColor = Colors.orange.withOpacity(0.5);
    EasyLoading().backgroundColor = Colors.black.withOpacity(0.3);
    EasyLoading().boxShadow = [BoxShadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 5), blurRadius: 10)];
    hud.show(
      // 显示的文本
      status: '显示的文本',
      indicator: Container(
        color: Colors.yellow,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/image_empty_1.png', width: 100, height: 100),
            const SizedBox(height: 10),
            const Text('加载完成', style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
      // 背景遮罩
      // maskType: EasyLoadingMaskType.clear,
      maskType: EasyLoadingMaskType.custom,  // 使用自定义的遮罩类型
      // maskColor: Colors.black.withOpacity(0.1)  // 设置浅透明背景，不支持这里设置
    );
    // 延迟 2 秒后关闭加载框
    Future.delayed(const Duration(seconds: 2), () {
      hud.dismiss();
    });

    // EasyLoading().maskColor = Colors.red.withOpacity(0.1);
  }

  // 发起网络请求
  void onGetRequest2() async {
  try {
    // 显示加载提示
    hud.show(status: '加载中...');
    // 发起网络请求
    final response = await appRequest.userInfo();
    // 打印返回结果
    print('用户信息: ${response.data}');
    // 隐藏加载提示
    hud.dismiss();
    // 显示成功提示
    if (response.code == 0) {
      hud.showSuccess('请求成功');
    } else {
      hud.showError('请求失败');
    }
  } catch (_) {}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: onGetRequest1, child: const Text('带图提示框')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onGetRequest2, child: const Text('发起 Get 请求'))
          ]
        )
      )
    );
  }
}