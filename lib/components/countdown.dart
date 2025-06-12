import 'dart:async';
import 'package:base_project/utils/public.dart';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  /// 目标时间戳（倒计时目标时间）
  final DateTime targetTime;
  /// 间隔时间（多久更新一次，默认 1 秒）
  final Duration intervalDuration;
  /// 文本样式
  final TextStyle? textStyle;
  /// 倒计时结束时的回调
  final VoidCallback? onComplete;

  const Countdown({
    super.key,
    required this.targetTime,
    this.intervalDuration = const Duration(seconds: 1),
    this.textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    this.onComplete,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  // 定时器
  Timer? _timer;
  // 剩余时间
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    // 计算剩余时间
    _remainingTime = widget.targetTime.difference(DateTime.now());
    // 只有在目标时间大于当前时间时才启动倒计时
    if (!_remainingTime.isNegative) {
      // 时间还未到，启动定时器
      _startTimer();
    }
  }

  // 启动定时器
  void _startTimer() {
    _timer = Timer.periodic(widget.intervalDuration, (timer) {
      if (mounted) {
        setState(() {
          _remainingTime = widget.targetTime.difference(DateTime.now());
        });
      }
      // 当剩余时间为负时，触发回调并停止定时器
      if (_remainingTime.isNegative) {
        _timer?.cancel();
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      }
    });
  }

  @override
  void dispose() {
    // 清理定时器
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _remainingTime.isNegative ? '00:00' : date.formatDuration(_remainingTime, showHours: _remainingTime.inHours > 0),
      style: widget.textStyle,
    );
  }
}
