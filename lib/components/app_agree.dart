import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';
import './alert.dart';

class AppAgree {
  static void show({
    /// 上下文
    required BuildContext context,
  }) async {
    // 是否已经同意
    final isAgree = await storage.getBoolPro(PublicKey.isAgree.value, defaultValue: false);
    if (isAgree) { return; }
    // 获取是否已经同意
    if (context.mounted) {
      CustomAlert.showWidget(
        context: context,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(adaptSize(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(adaptSize(16))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Center(
                    child: Text('温馨提示', style: TextStyle(fontSize: adaptFontSize(18), color: const Color(0xFF313131), fontWeight: FontWeight.w500)),
                  ),
                  // 内容
                  SizedBox(height: adaptSize(10)),
                  Text(
                    '欢迎您使用水哥自用框架APP。我们非常重视您的个人信息和隐私保护，我们将通过《隐私权保护政策》帮助您了解我们收集、使用、存储、共享和保护个人信息的情况，以及您所享有的相关权利。',
                    style: TextStyle(
                      fontSize: adaptFontSize(14),
                      color: const Color(0xFF383838),
                      height: 1.6,
                    ),
                  ),
                  // 协议
                  SizedBox(height: adaptSize(10)),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: const Color(0xFF323233),
                        fontSize: adaptFontSize(14),
                      ),
                      children: <InlineSpan>[
                        const TextSpan(text: '请您阅读'),
                        TextSpan(
                          text: '《服务协议》',
                          style: const TextStyle(
                            color: primaryTextColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nav.toNamed(appRoutes.webview, parameters: {'url': agrServerUrl});
                          }
                        ),
                        const TextSpan(text: '和'),
                        TextSpan(
                          text: '《隐私政策》',
                          style: const TextStyle(
                            color: primaryTextColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nav.toNamed(appRoutes.webview, parameters: {'url': agrPrivacyUrl});
                          }
                        ),
                      ]
                    ),
                  ),
                  // 同意并继续
                  SizedBox(height: adaptSize(14)),
                  InkWell(
                    onTap: () {
                      // 设置是否同意
                      storage.setBool(PublicKey.isAgree.value, true);
                      // 关闭弹窗
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: adaptSize(44),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(adaptSize(44))),
                      ),
                      child: Center(
                        child: Text('同意并进入', style: TextStyle(fontSize: adaptFontSize(14), color: Colors.white)),
                      ),
                    ),
                  ),
                  // 不同意并退出
                  SizedBox(height: adaptSize(12)),
                  InkWell(
                    onTap: () {
                      // 退出app
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    },
                    child: Center(
                      child: Text('不同意并退出', style: TextStyle(fontSize: adaptFontSize(14), color: const Color(0xFF939393))),
                    ),
                  )
                ],
              )
            )
          ]
        )
      );
    }
  }
}
