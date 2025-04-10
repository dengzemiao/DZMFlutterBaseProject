import 'package:flutter/material.dart';
import './index.dart';
import './logs.dart';

class LogButton {
  // 悬浮视图
  static OverlayEntry? _overlayEntry;
  /// 显示日志按钮
  static void show(BuildContext context) {
    // 是否开启
    if (!Logs().isEnable) return;
    // 防止重复添加
    if (_overlayEntry != null) return;
    // 初始位置
    double x = MediaQuery.of(context).size.width - 80;
    double y = MediaQuery.of(context).size.height - 200;
    // 创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: x,
        top: y,
        child: GestureDetector(
          onPanUpdate: (details) {
            // 更新位置
            x += details.delta.dx;
            y += details.delta.dy;
            // 更新 OverlayEntry
            _overlayEntry?.markNeedsBuild();
          },
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('全局悬浮按钮被点击！'))
              // );
              if (!Logs().isInTheLogPage) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogController()),
                );
              }
            },
            child: const Icon(Icons.bug_report, color: Colors.white),
          )
        ),
      ),
    );
    // 添加到 Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }
  /// 移除日志按钮
  static void remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}