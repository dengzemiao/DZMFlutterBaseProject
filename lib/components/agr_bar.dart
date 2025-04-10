import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// import 'package:get/get.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';

class AgrBar extends StatefulWidget {

  /// 是否勾选
  final bool isChecked;
  /// 切换回调
  final ValueChanged<bool>? onChanged;

  const AgrBar({
    super.key,
    this.isChecked = false,
    this.onChanged
  });

  @override
  State<AgrBar> createState() => _AgrBarState();
}

class _AgrBarState extends State<AgrBar> {

  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        // 从头开始
      mainAxisAlignment: MainAxisAlignment.start,
      // 垂直居中
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 勾选框
        InkWell(
          onTap: () {
            setState(() {
              // 切换勾选状态
              _isChecked = !_isChecked;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(_isChecked);
            }
          },
          child: Image.asset(
            _isChecked
                ? 'assets/images/image_radio_select.png'
                : 'assets/images/image_radio_normal.png',
            width: adaptSize(20.0),
            height: adaptSize(20.0),
          ),
        ),
        SizedBox(width: adaptSize(8.0),),
        // 文字
       Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: const Color(0xFF323233),
                fontSize: adaptFontSize(12),
              ),
              children: <InlineSpan>[
                const TextSpan(text: '同意'),
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
       )
      ]
    );
  }
}