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
            permission.listenNetworkOnce((isConnected) {
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
}