import 'package:flutter/material.dart';
// import 'package:base_project/utils/public.dart';

@immutable
class TagItem extends StatefulWidget {

  /// 宽度
  final double? width;
  /// 高度
  final double? height;
  /// 文本
  final String? text;
  /// 文本样式
  final TextStyle? textStyle;
  /// 背景颜色
  final Color? backgroundColor;
  /// 边框颜色
  final Color? borderColor;
  /// 圆角
  final double? borderRadius;
  /// 内边距
  final EdgeInsetsGeometry? padding;
  /// 外边距
  final EdgeInsetsGeometry? margin;

  const TagItem({
    super.key,
    this.width,
    this.height,
    this.text,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.margin
  });

  @override
  State<TagItem> createState() => TagItemState();
}

class TagItemState extends State<TagItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.borderColor != null ? Border.all(color: widget.borderColor!, width: 0.5) : null,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)
      ),
      child: Center(
        child: Text(
          widget.text ?? '',
          style: widget.textStyle
        ),
      )
    );
  }
}