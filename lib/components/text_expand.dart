import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';

class TextExpand extends StatefulWidget {
  /// 文案
  final String? text;
  /// 文案样式
  final TextStyle? style;
  /// 最大行数
  final int maxLines;
  /// 因为获取的宽度是屏幕的宽度，需要去除文本框外左右总间距，可以适当调整。
  final double? reduceWidth;
  /// 展开按钮文案样式
  final TextStyle? expandStyle;
  /// 展开按钮左侧空白区域
  final double? expandLeft;
  /// 是否展开
  final bool isExpanded;
  /// 是否隐藏收起
  final bool isHideShrink;

  const TextExpand({
    super.key,
    this.text,
    this.style,
    this.maxLines = 3,
    this.reduceWidth,
    this.expandStyle,
    this.expandLeft,
    this.isExpanded = false,
    this.isHideShrink = false
  });

  @override
  State<TextExpand> createState() => _TextExpandState();
}

class _TextExpandState extends State<TextExpand> {
  // 是否展开
  bool _isExpanded = false;
  // 是否需要显示展开按钮
  bool _showExpandButton = false;

  @override
  void initState() {
    super.initState();
    // 是否展开
    _isExpanded = widget.isExpanded;
  }

  // 点击展开/收起
  void _onExpanded () {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// 展开按钮
  Widget _buildExpandButton ({
    double oneLinesHeight = 0
  }) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: InkWell(
        onTap: () => _onExpanded(),
        child: Container(
          height: oneLinesHeight,
          padding: EdgeInsets.fromLTRB(widget.expandLeft ?? adaptSize(12), 0, 0, 0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/image_bg_11.png'),
              fit: BoxFit.fill
            )
          ),
          child: Center(
            child: Text(
              _isExpanded ? '收起' : '展开',
              style: widget.expandStyle ?? TextStyle(fontSize: adaptFontSize(11), color: primaryColor),
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // 需要减去的宽度
    final reduceWidth = widget.reduceWidth ?? 0;
    // 计算文本最大宽度
    final double maxWidth = MediaQuery.of(context).size.width - reduceWidth;
    // 计算完整文本的总高度
    final double fullTextHeight = calcTextHeight(
      text: widget.text,
      style: widget.style,
      maxWidth: maxWidth,
    );
    // 计算限制为指定行时的文本高度
    final double threeLinesHeight = calcTextHeight(
      text: widget.text,
      style: widget.style,
      maxWidth: maxWidth,
      maxLines: widget.maxLines,
    );
    // 计算限制为 1 行时的文本高度
    final double oneLinesHeight = calcTextHeight(
      text: widget.text,
      style: widget.style,
      maxWidth: maxWidth,
      maxLines: 1,
    );
    // 是否显示展开按钮
    _showExpandButton = fullTextHeight > threeLinesHeight;
    // log('fullTextHeight: $fullTextHeight, threeLinesHeight: $threeLinesHeight, oneLinesHeight: $oneLinesHeight');
    return Stack(
      children: [
        // 文案
        Text(
          widget.text ?? '',
          style: widget.style,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        // 展开按钮
        if (_showExpandButton)
          if (_isExpanded && widget.isHideShrink)
            const SizedBox()
          else
            _buildExpandButton(oneLinesHeight: oneLinesHeight)
      ],
    );
  }
}
