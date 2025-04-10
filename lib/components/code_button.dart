import 'dart:async';
import 'package:flutter/material.dart';
import 'package:base_project/utils/constant.dart';
import 'package:base_project/utils/public.dart';

class CodeButton extends StatefulWidget {

  /// 允许点击
  final bool allowTap;
  /// 倒计时的秒数
  final int seconds;
  /// 获取验证码
  final VoidCallback? onTap;

  const CodeButton({
    super.key,
    this.allowTap = false,
    this.seconds = 60,
    this.onTap
  });

  @override
  State<CodeButton> createState() => _CodeButtonState();
}

class _CodeButtonState extends State<CodeButton> {
  /// 是否正在倒计时
  bool _isCounting = false;
  /// 倒计时的秒数
  late int _seconds;
  /// 倒计时
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
  }

  /// 开始倒计时
  void _startCountdown() {
    if (!widget.allowTap || _isCounting) return;
    setState(() { _isCounting = true; });
    // 倒计时定时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        if (mounted) {
          setState(() {
            _seconds--;
          });
        }
      } else {
        _stopCountdown();
      }
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  /// 停止倒计时
  void _stopCountdown() {
    _removeTimer();
    if (mounted) {
      setState(() {
        _isCounting = false;
        _seconds = widget.seconds;
      });
    }
  }

  /// 移除定时器
  void _removeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _removeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isCounting ? null : _startCountdown,
      child: Container(
        width: 150,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: !widget.allowTap || _isCounting ? primaryDisabledColor : primaryColor,
          borderRadius: BorderRadius.circular(adaptSize(6)),
        ),
        child: Text(
          _isCounting ? '$_seconds 秒' : '获取验证码',
          style: TextStyle(
            color: Colors.white,
            fontSize: adaptFontSize(12)
          ),
        ),
      ),
    );
  }
}
