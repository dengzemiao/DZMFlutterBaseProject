import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';
import './image_view.dart';

@immutable
class EmptyView extends StatefulWidget {

  // 图片路径
  final String? imageUrl;
  /// 标题
  final String? title;
  /// 描述
  final String? desc;
  // 隐藏返回按钮
  final bool hideBack;
  /// 返回按钮事件，传入则自行实现返回操作
  final VoidCallback? onBack;

  const EmptyView({
    super.key,
    this.imageUrl,
    this.title,
    this.desc,
    this.hideBack = true,
    this.onBack
  });

  @override
  State<EmptyView> createState() => EmptyViewState();
}

class EmptyViewState extends State<EmptyView> {

  /// 图片宽度
  final double imageWidth = adaptSize(184);
  /// 图片高度
  final double imageHeight = adaptSize(184);
  /// 标题字体大小
  final double titleFontSize = adaptFontSize(15);
  /// 描述字体大小
  final double descFontSize = adaptFontSize(12);
  
  void onBack () {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      nav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: adaptSize(100)),
          // 图片
          if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            CustomImageView(
              imageUrl: widget.imageUrl!,
              width: imageWidth,
              height: imageHeight,
            ),
          // 标题
          if (widget.title != null && widget.title!.isNotEmpty)
            ...[
              SizedBox(height: adaptSize(12)),
              Text(widget.title!, style: TextStyle(fontSize: titleFontSize, color: const Color(0xFF202020)))
            ],
          // 描述
          if (widget.desc != null && widget.desc!.isNotEmpty)
            ...[
              SizedBox(height: adaptSize(6)),
              Text(widget.desc!, style: TextStyle(fontSize: descFontSize, color: const Color(0xFF9B9CA2))),
            ],
          // 返回按钮
          if (!widget.hideBack)
            ...[
              SizedBox(height: adaptSize(43)),
              InkWell(
                onTap: onBack,
                child: Container(
                  width: adaptSize(120),
                  height: adaptSize(36),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(adaptSize(4)),
                  ),
                  child: Text('返 回', style: TextStyle(fontSize: adaptFontSize(15), color: const Color(0xFF202020))),
                ),
              )
            ]
        ],
      ),
    );
  }
}