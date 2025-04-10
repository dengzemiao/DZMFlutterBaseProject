import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';

@immutable
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  /// 标题
  final String? title;
  /// 标题 Widget
  final Widget? titleWidget;
  /// 背景颜色
  final Color? backgroundColor;
  /// 返回图标
  final String? leftIcon;
  /// 返回额外间距
  final double leftIconLeftSpacing;
  /// 返回回调（需要自己实现返回操作）
  final VoidCallback? onLeftCallback;
  /// 右侧图标
  final String? rightIcon;
  /// 右侧额外间距
  final double rightIconRightSpacing;
  /// 右侧回调
  final VoidCallback? onRightCallback;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.backgroundColor = Colors.white,
    this.leftIcon = 'assets/images/image_back_0.png',
    this.leftIconLeftSpacing = 0,
    this.onLeftCallback,
    this.rightIcon,
    this.rightIconRightSpacing = 0,
    this.onRightCallback
  });

  @override
  Size get preferredSize => Size.fromHeight(navBarHeight);

  @override
  State<CustomAppBar> createState() => CustomAppBarState();
}

class CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = getStatusBarHeight(context);
    return Container(
      height: statusBarHeight + navBarHeight,
      color: widget.backgroundColor ?? appBarTheme.backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Stack(
          children: [
            // 标题
            widget.titleWidget ?? Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: adaptSize(80)),
                child: Text(
                  widget.title ?? '',
                  style: appBarTheme.titleTextStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            // 返回
            if (widget.leftIcon != null)
              Positioned(
                top: 0,
                left: widget.leftIconLeftSpacing,
                height: navBarHeight,
                width: adaptSize(40),
                child: InkWell(
                  onTap: () {
                    if (widget.onLeftCallback != null) {
                      widget.onLeftCallback!();
                    } else {
                      nav.back();
                    }
                  },
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(widget.leftIcon!, width: adaptSize(24), height: adaptSize(24))
                      ],
                    )
                  ),
                )
              ),
            // 右侧图标
            if (widget.rightIcon != null)
              Positioned(
                top: 0,
                right: widget.rightIconRightSpacing,
                height: navBarHeight,
                width: adaptSize(40),
                child: InkWell(
                  onTap: () {
                    if (widget.onRightCallback != null) {
                      widget.onRightCallback!();
                    }
                  },
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(widget.rightIcon!, width: adaptSize(24), height: adaptSize(24))
                      ],
                    )
                  ),
                )
              )
          ],
        )
      ),
    );
  }
}