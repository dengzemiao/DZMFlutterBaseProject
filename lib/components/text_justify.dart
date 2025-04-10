import 'package:flutter/material.dart';

@immutable
class TextJustify extends StatefulWidget {
  /// 文案
  final String? text;
  /// 文案样式
  final TextStyle? style;
  /// 宽度
  final double? width;
  /// 高度
  final double? height;

  const TextJustify({
    super.key,
    this.text,
    this.style,
    this.width,
    this.height,
  });

  @override
  State<TextJustify> createState() => _TextJustifyState();
}

class _TextJustifyState extends State<TextJustify> {
  @override
  Widget build(BuildContext context) {
    // 确保 text 不为 null 或空字符串
    final String text = widget.text ?? '';
    // 将字符串拆分为字符数组
    final List<String> characters = text.split('');
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        children: [
          for (int i = 0; i < characters.length; i++) ...[
            Text(characters[i], style: widget.style),
            // 在最后一个字符后不添加 Spacer
            if (i < characters.length - 1) const Spacer(),
          ],
        ],
      ),
    );
  }
}
