import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/components/alert.dart';

class AlertController extends BaseStatefulController {
  
  const AlertController({super.key, super.title});

  @override
  AlertControllerState createState() => AlertControllerState();
}

class AlertControllerState extends BaseStatefulControllerState {
  
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            CustomAlert.show(
              context: context,
              text: '确定要退出登录吗?',
              onConfirm: (value) {
                if (value) {
                }
              }
            );
          },
          child: const Text('Alert 弹窗'),
        ),
        ElevatedButton(
          onPressed: () {
            CustomAlert.show(
              context: context,
              icon: 'assets/images/image_alert_success.png',
              text: '18888888888',
              // desc: '复制号码',
              confirmText: '复制号码',
              hideCancel: true,
              onConfirm: (value) {
                if (value) {
                }
              }
            );
          },
          child: const Text('Alert 单个按钮'),
        ),
        ElevatedButton(
          onPressed: () {
            CustomAlert.show(
              context: context,
              text: '18888888888',
              descWidget: Column(
                children: [
                  SizedBox(height: adaptSize(12)),
                  Container(
                    width: adaptSize(270),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(adaptSize(8))
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: adaptSize(10), horizontal: adaptSize(18)),
                      child: Text(
                        'xxxx给你分享了一个激活码，快来领取激活吧。#微信#课程激活口令#ABCDABCD#。复制后打开【微信】App或在【微信】App首页搜索激活',
                        style: TextStyle(
                          color: const Color(0xFF7E7E7E),
                          fontSize: adaptFontSize(12)
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: false,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  )
                ],
              ),
              onConfirm: (value) {
                if (value) {
                }
              }
            );
          },
          child: const Text('Alert 自定义描述内容'),
        ),
        ElevatedButton(
          onPressed: () {
            CustomAlert.show(
              context: context,
              onConfirm: (value) {
                if (value) {
                  logout();
                }
              },
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '是否核销',
                          style: TextStyle(
                            fontSize: adaptFontSize(16),
                            color: const Color(0xFF353535)
                          )
                        ),
                        TextSpan(
                          text: ' 1 ',
                          style: TextStyle(
                            fontSize: adaptFontSize(16),
                            color: const Color(0xFFFF5A63)
                          )
                        ),
                        TextSpan(
                          text: '次',
                          style: TextStyle(
                            fontSize: adaptFontSize(16),
                            color: const Color(0xFF353535)
                          )
                        )
                      ]
                    )
                  ),
                  SizedBox(height: adaptSize(13)),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: adaptFontSize(16),
                        color: const Color(0xFF353535)
                      ),
                      children: const [
                        TextSpan(text: '还剩'),
                        TextSpan(
                          text: ' 60 ',
                          style: TextStyle(
                            color: Color(0xFFFF5A63)
                          )
                        ),
                        TextSpan(text: '次未核销'),
                      ]
                    )
                  ),
                ]
              )
            );
          },
          child: const Text('Alert 自定义标题内容'),
        ),
        ElevatedButton(
          onPressed: () {
            CustomAlert.showWidget(
              context: context,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: adaptSize(100),
                  height: adaptSize(100),
                  color: Colors.red,
                  child: Center(
                    child: Text('点我关闭', style: TextStyle(color: Colors.white, fontSize: adaptFontSize(16)))),
                )
              )
            );
          },
          child: const Text('Alert 完全自定义内容'),
        ),
        ElevatedButton(
          onPressed: () {
            CustomBottomSheet.show(
              context: context,
              list: ['退出登录', '是否核销 1 次'],
            );
          },
          child: const Text('BottomSheet 弹窗'),
        ),
        ElevatedButton(
          onPressed: () {
            CustomBottomSheet.showWidget(
              context: context,
              title: '全部分类',
              backgroundColor: Colors.red,
              child: SizedBox(
                width: double.infinity,
                height: adaptSize(100),
              )
            );
          },
          child: const Text('BottomSheet 自定义弹窗内容'),
        )
      ]
    );
  }
}