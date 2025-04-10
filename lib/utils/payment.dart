import 'package:flutter/material.dart';
// import 'package:base_project/utils/public.dart';
// import 'package:base_project/model/order.dart';
import 'package:base_project/components/alert.dart';

class Payment {

  // 静态变量存储单例
  static final Payment _instance = Payment._internal();
  // 静态方法获取单例实例
  factory Payment() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Payment._internal();

  /// 支付（二次确认）
  void confirm ({
    /// 上下文
    required BuildContext context,
    /// 课程ID
    int? courseID,
    /// 订单ID
    int? transactionID,
    /// 回调
    ValueChanged<int?>? onConfirm
  }) async {
    CustomAlert.show(
      context: context,
      text: '是否确认支付?',
      onConfirm: (value) async {
        if (value) {
          // 参数
          final params = {
            if (courseID != null) 'course_id': courseID,
          };
          // 发起请求
          final transactionId = await send(params);
          // 回调
          if (onConfirm != null) { onConfirm(transactionId); }
        }
      }
    );
  }

  /// 支付
  Future<int?> send (params) async {
    // try {
    //   // 显示加载
    //   hud.show(status: '支付中...');
    //   // 发起网络请求
    //   final response = await appRequest.orderSubmit(params);
    //   // 成功
    //   if (response.code == 0) {
    //     // 提示
    //     hud.showToast('支付成功\n\n请激活后在订阅的课程中使用和观看');
    //      // 数据
    //     final data = response.data['transaction'];
    //     // 转换模型
    //     final model = OrderModel.fromJson(data);
    //     // 返回
    //     return model.transactionId;
    //   } else {
    //     // 提示
    //     hud.showToast(response.msg ?? '支付失败');
    //     // 返回
    //     return null;
    //   }
    // } catch (_) {
    //   // 提示
    //   hud.showToast('支付失败');
    //   // 返回
    //   return null;
    // }
    return null;
  }
}