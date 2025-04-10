import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 图片模式
enum CustomImageViewMode {
    
  /// 根据 imageUrl 自行判断使用 CachedNetworkImage 还是 Image.asset
  none(value: 'none'),
  /// 本地图片
  asset(value: 'asset'),
  /// 网络图片
  network(value: 'network');

  /// value
  final String value;
  const CustomImageViewMode({ required this.value });
}

class CustomImageView extends StatelessWidget {
  // 图片路径
  final String? imageUrl;
  /// 宽度
  final double? width;
  /// 高度
  final double? height;
  /// 填充模式
  final BoxFit? fit;
  /// 图片模式
  final CustomImageViewMode? mode;
  /// 圆角
  final BorderRadiusGeometry? borderRadius;
  /// 背景颜色
  final Color? backgroundColor;
  /// 外部传入占位图
  final Widget? placeholder;
  /// 外部传入错误图
  final Widget? errorWidget;

  const CustomImageView({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.backgroundColor,
    this.mode = CustomImageViewMode.none,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {

    // 判断 imageUrl 是否是一个有效的 URL
    bool isNetworkImage = (imageUrl ?? '').startsWith('http');
    // 设置默认占位图
    Widget defaultPlaceholder = Container();
    // 错误图
    Widget defaultErrorWidget = const Icon(Icons.error);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: (
          imageUrl == null ? 
          null
          : 
          (
            ((mode == CustomImageViewMode.none && isNetworkImage) || mode == CustomImageViewMode.network)
            ?
            // 网络图片，使用 CachedNetworkImage
            CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => placeholder ?? defaultPlaceholder,
              errorWidget: (context, url, error) => errorWidget ?? defaultErrorWidget,
            )
            :
            // 本地图片，使用 Image.asset
            Image.asset(
              imageUrl!,
              width: width,
              height: height,
              fit: fit
            )
          )
        )
        ,
      )
    );
  }
}
