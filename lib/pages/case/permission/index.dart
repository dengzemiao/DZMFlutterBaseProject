// import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';

class PermissionController extends BaseStatefulController {
  
  const PermissionController({super.key, super.title});

  @override
  PermissionControllerState createState() => PermissionControllerState();
}

class PermissionControllerState extends BaseStatefulControllerState {
  
  late bool isNetworkConnected = false;

  @override
  Widget? buildBody(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // 添加持久监听，网络状态变化时，会调用此方法
            network.addPersistentListener(_handleNetworkChange);
            // 添加一次性监听，网络连接成功时，会调用此方法
            network.addOneTimeListener(({required results, required isConnected}) {
              logs.add({logs.keyTitle: '检查网络结果：$isConnected', logs.keySuccess: isConnected});
              setState(() {
                isNetworkConnected = isConnected;
              });
            });
          },
          child: Text('手动点击，检查网络 $isNetworkConnected'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 持久监听如果不需要，需要手动移除
    network.removePersistentListener(_handleNetworkChange);
  }

  /// 网络状态变化回调
  void _handleNetworkChange({required results, required isConnected}) {
    log('network.addPersistentListener: $isConnected');
    if (isConnected) {
      // 操作当前页面的网络数据
    }
  }
}