import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  // 虚线颜色
  final Color color;
  // 虚线宽度
  final double strokeWidth;
  // 每段虚线的宽度
  final double dashWidth;
  // 虚线之间的间隔
  final double dashSpace;
  // 虚线方向（水平或垂直）
  final Axis direction;

  DashedLinePainter({
    this.color = Colors.blue,
    this.strokeWidth = 1.0,
    this.dashWidth = 6.0,
    this.dashSpace = 3.0,
    this.direction = Axis.horizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // 起始点
    double startX = 0;
    double startY = 0;

    if (direction == Axis.horizontal) {
      // 水平虚线
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        // 更新起点
        startX += dashWidth + dashSpace;
      }
    } else {
      // 垂直虚线
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth),
          paint,
        );
        // 更新起点
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedLine extends StatelessWidget {
  /// 容器尺寸：Size(容器宽度，容器高度)
  final Size? size;
  // 虚线颜色
  final Color color;
  // 虚线宽度
  final double strokeWidth;
  // 每段虚线的宽度
  final double dashWidth;
  // 虚线之间的间隔
  final double dashSpace;
  // 虚线方向（水平或垂直）
  final Axis direction;

  const DashedLine({
    super.key,
    this.size,
    this.color = Colors.blue,
    this.strokeWidth = 1.0,
    this.dashWidth = 6.0,
    this.dashSpace = 3.0,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size ?? const Size(double.infinity, 1.0),
      painter: DashedLinePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        direction: direction,
      ),
    );
  }
}
