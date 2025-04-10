import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/components/image_view.dart';

@immutable
class ActionBar extends StatefulWidget {

  /// 左侧图标
  final String? leftIcon;
  /// 左侧图标右侧间距
  final double? leftIconRightSpacing;
  /// 左侧图标大小（内部会 adaptSize 处理）
  final double? leftIconSize;
  /// 左侧图标圆角
  final BorderRadiusGeometry? leftIconBorderRadius;
  /// 头部标题
  final String? title;
  /// 头部标题字号（内部会 adaptSize 处理）
  final double? titleFontSize;
  /// 头部标题颜色
  final Color titleColor;
  /// 头部标题字重
  final FontWeight titleFontWeight;
  /// 尾部描述
  final String? desc;
  /// 尾部描述字号（内部会 adaptSize 处理）
  final double? descFontSize;
  /// 尾部描述颜色
  final Color descColor;
  /// 尾部描述字重
  final FontWeight descFontWeight;
  /// 右侧图标(默认箭头)
  final String? rightIcon;
  /// 右侧图标大小（内部会 adaptSize 处理）
  final double? rightIconSize;
  /// 右侧图标左侧间距
  final double? rightIconLeftSpacing;
  
  const ActionBar({
    super.key,
    this.leftIcon,
    this.leftIconRightSpacing,
    this.leftIconSize,
    this.leftIconBorderRadius,
    this.title,
    this.titleFontSize,
    this.titleColor = const Color(0xFF3B3A42),
    this.titleFontWeight = FontWeight.w500,
    this.desc,
    this.descFontSize,
    this.descColor = const Color(0xFF969799),
    this.descFontWeight = FontWeight.normal,
    this.rightIcon = 'assets/images/image_arrow_1.png',
    this.rightIconSize,
    this.rightIconLeftSpacing
  });

  @override
  State<ActionBar> createState() => ActionBarState();
}

class ActionBarState extends State<ActionBar> {
 
  /// 左侧图标大小
  final double leftIconSize = adaptSize(24);
  /// 左侧图标右侧间距
  final double leftIconRightSpacing = adaptSize(11);
  /// 头部标题字号
  final double titleFontSize = adaptFontSize(14);
  /// 尾部描述字号
  final double descFontSize = adaptFontSize(14);
  /// 左侧图标大小
  final double rightIconSize = adaptSize(24);
  /// 右侧图标左侧间距
  final double rightIconLeftSpacing = adaptSize(4);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧图标
        if (widget.leftIcon != null)
          ...[
            // Image.asset(widget.leftIcon!, width: widget.leftIconSize ?? leftIconSize, height: widget.leftIconSize ?? leftIconSize),
            CustomImageView(
              imageUrl: widget.leftIcon!,
              width: widget.leftIconSize ?? leftIconSize,
              height: widget.leftIconSize ?? leftIconSize,
              borderRadius: widget.leftIconBorderRadius,
              fit: BoxFit.cover,
            ),
            SizedBox(width: widget.leftIconRightSpacing ?? leftIconRightSpacing),
          ],
        // 标题
        if (widget.title != null)
          Text(widget.title!, style: TextStyle(fontSize: widget.titleFontSize ?? titleFontSize, color: widget.titleColor, fontWeight: widget.titleFontWeight)),
        // 撑开
        const Spacer(),
        // 尾部描述
        if (widget.desc != null)
          Text(widget.desc!, style: TextStyle(fontSize: widget.descFontSize ?? descFontSize, color: widget.descColor, fontWeight: widget.descFontWeight)),
        // 右侧图标
        if (widget.rightIcon != null && widget.rightIcon!.isNotEmpty)
          ...[
            SizedBox(width: widget.rightIconLeftSpacing ?? rightIconLeftSpacing),
            Image.asset(widget.rightIcon!, width: widget.rightIconSize ?? rightIconSize, height: widget.rightIconSize ?? rightIconSize)
          ]
      ]
    );
  }
}