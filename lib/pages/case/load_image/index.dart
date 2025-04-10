import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:base_project/utils/public.dart';

class LoadImageController extends BaseStatefulController {

  const LoadImageController({super.key, super.title});
  
  @override
  LoadImageControllerState createState() => LoadImageControllerState();
}

class LoadImageControllerState extends BaseStatefulControllerState {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null ? AppBar(title: Text(widget.title!)) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 间距
            const SizedBox(height: 10.0),
            // icon
            const Icon(Icons.home),
            // 间距
            const SizedBox(height: 10.0),
            // 本地图片
            Image.asset(
              // 图片路径
              'assets/images/a_temp.png',
              // 设置宽度
              width: double.infinity,
              // 设置高度
              height: 100.0,
              // 设置填充模式
              fit: BoxFit.cover
            ),
            // 间距
            const SizedBox(height: 10.0),
            // 图片展示
            Container(
              width: double.infinity,
              height: adaptSize(100.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider('https://q6.itc.cn/q_70/images03/20240126/4eaa7950e4214e8e83965f851318a03d.jpeg'),
                  fit: BoxFit.cover,  // 这将确保 fit 在网络图片上生效
                ),
              ),
            ),
            // 间距
            const SizedBox(height: 10.0),
            // 网络图片(显示占位图片)
            CachedNetworkImage(
              imageUrl: 'https://example.com/image.jpg', // 替换为图片的URL
              width: double.infinity,
              height: adaptSize(100.0),
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset('assets/images/a_temp.png', fit: BoxFit.cover),  // 使用本地占位图片
              errorWidget: (context, url, error) => const Icon(Icons.error)
            ),
            // 间距
            const SizedBox(height: 10.0),
            // 网络图片
            CachedNetworkImage(
              imageUrl: 'https://q6.itc.cn/q_70/images03/20240126/4eaa7950e4214e8e83965f851318a03d.jpeg', // 替换为图片的URL
            ),
            // 间距
            const SizedBox(height: 10.0),
            // 网络图片(占位加载)
            CachedNetworkImage(
              imageUrl: 'https://q6.itc.cn/q_70/images03/20240126/4eaa7950e4214e8e83965f851318a03d.jpeg', // 替换为图片的URL
              placeholder: (context, url) => const CircularProgressIndicator(), // 占位符
              errorWidget: (context, url, error) => const Icon(Icons.error), // 错误占位符
            ),
            // 间距
            const SizedBox(height: 10.0),
            // 网络图片(淡入淡出)
            CachedNetworkImage(
              imageUrl: 'https://q6.itc.cn/q_70/images03/20240126/4eaa7950e4214e8e83965f851318a03d.jpeg', // 替换为图片的URL
              fadeInDuration: const Duration(milliseconds: 3000), // 设置淡入时长
              fadeOutDuration: const Duration(milliseconds: 3000), // 设置淡出时长
              placeholder: (context, url) => const CircularProgressIndicator(), // 占位符
              errorWidget: (context, url, error) => const Icon(Icons.error), // 错误占位符
            ),
            // 间距
            const SizedBox(height: 10.0),
            // 网络图片(失败时显示占位符)
            CachedNetworkImage(
              imageUrl: 'https://q6.itc.cn/q_70/images03/20240126/4eaa7950e4214e8e83965f851318a03d1.jpeg', // 替换为图片的URL
              placeholder: (context, url) => const CircularProgressIndicator(), // 占位符
              errorWidget: (context, url, error) => const Icon(Icons.error), // 错误占位符
            )
          ]
        )
      )
    );
  }
}