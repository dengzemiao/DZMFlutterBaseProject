// import 'package:flutter/material.dart';
import 'package:base_project/base/refresh/index.dart';

class CaseController extends BaseRefreshController {
  
  const CaseController({super.key, super.title});

  @override
  CaseControllerState createState() => CaseControllerState();
}

class CaseControllerState extends BaseRefreshControllerState {
  
  // @override
  // void initState() {
  //   // 如果不需要初始化自动下拉加载，这里关闭，其他需要调整的也可以这里提前处理
  //   // initialRefresh = false;
  //   super.initState();
  //   // 开始加载
  //   setState(() { isLoading = true; });
  //   /// 延迟获取数据
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() {
  //       dataSource = List.generate(20, (index) => "Item $index");
  //       // 打开上拉加载
  //       enablePullUp = true;
  //       // 结束加载
  //       isLoading = false;
  //     });
  //   });
  // }
}