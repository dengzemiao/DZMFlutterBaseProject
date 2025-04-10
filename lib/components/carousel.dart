import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:base_project/model/banner.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';
import 'package:base_project/components/image_view.dart';

@immutable
class Carousel extends StatefulWidget {

  /// Banners
  final List<BannerModel> banners;
  
  const Carousel({
    super.key,
    required this.banners,
  });

  @override
  State<Carousel> createState() => CarouselState();
}

class CarouselState extends State<Carousel> {

  // 点击事件
  void onTap (BannerModel model) {
    // if (model.type == 3) {
    //   // 链接
    //   if (model.content != null && model.content!.isNotEmpty) {
    //     // nav.open(model.content ?? '');
    //     nav.toNamed(appRoutes.webview, parameters: {'url': model.content!});
    //   }
    // } else if (model.type == 2) {
    //   // 课程
    //   // nav.toNamed(appRoutes.courseDetail, parameters: {'id': model.content ?? ''});
    // } else {
    //   // 无效果
    //   // nav.toNamed(appRoutes.webview, parameters: {'url': 'https://www.baidu.com'});
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // 阴影颜色
            color: primaryColor.withOpacity(0.2),
            // 设置阴影朝下的方向，dy 值大于 0 表示向下
            offset: const Offset(0, 10),
            // 阴影模糊半径
            blurRadius: 20,
            // 阴影扩散半径
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: widget.banners.isEmpty ? Container(height: adaptSize(150)) : FlutterCarousel(
          options: FlutterCarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            height: adaptSize(150),
            viewportFraction: 1.0,
            indicatorMargin: adaptSize(12.0),
            enableInfiniteScroll: true,
            slideIndicator: CircularSlideIndicator(),
            initialPage: 0,
          ),
          items: widget.banners.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () => onTap(item),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.5),
                    ),
                    child: CustomImageView(
                      imageUrl: item.picture ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  )
                );
              },
            );
          }).toList(),
        )
      )
    );
  }
}