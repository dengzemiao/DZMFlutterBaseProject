import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Camera {

  // 静态变量存储单例
  static final Camera _instance = Camera._internal();
  // 静态方法获取单例实例
  factory Camera() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Camera._internal();

  // 静态的 _picker 变量，确保只会初始化一次
  final ImagePicker _picker = ImagePicker();

  // 打开相机
  Future<void> showCamera({
    bool? cropping,
    ValueChanged<String>? onChanged
  }) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        if (cropping == true) {
          await _cropImage(
            path: file.path,
            onChanged: onChanged
          );
        } else {
          if (onChanged != null) { onChanged(file.path); }
        }
      } else {
        if (onChanged != null) { onChanged(''); }
      }
    } catch (e) {
      if (onChanged != null) { onChanged(''); }
      // print('图片选择出错: $e');
    }
  }

  // 打开相册
  Future<void> showAlbum({
    bool? cropping,
    ValueChanged<String>? onChanged
  }) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        if (cropping == true) {
          await _cropImage(
            path: file.path,
            onChanged: onChanged
          );
        } else {
          if (onChanged != null) { onChanged(file.path); }
        }
      } else {
        if (onChanged != null) { onChanged(''); }
      }
    } catch (e) {
      // print('图片选择出错: $e');
      if (onChanged != null) { onChanged(''); }
    }
  }

  ///【只支持iOS】扫描二维码，返回扫描结果；取消或失败返回 '-1'
  // Future<void> showScan({
  //   ValueChanged<String>? onChanged
  // }) async {
  //   String scanResult = await FlutterBarcodeScanner.scanBarcode(
  //     // 扫描框颜色
  //     '#00FF00', 
  //     // 取消按钮文本
  //     '取消',
  //     // 是否显示闪光灯按钮
  //     false,
  //     // 设置扫描模式为二维码
  //     ScanMode.QR
  //   );
  //   // 回调
  //   if (onChanged != null) { onChanged(scanResult); }
  // }
  
  // 图片裁剪方法
  Future<void> _cropImage({
    required String path,
    ValueChanged<String>? onChanged
  }) async {
    try {
      // 使用 image_cropper 进行裁剪
      final file = await ImageCropper().cropImage(
        sourcePath: path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪图片',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: false
          ),
        ]
      );
      // 如果裁剪成功
      if (file != null && onChanged != null) {
        // 图片裁剪成功，返回裁剪后的图片
        onChanged(file.path);
      }
    } catch (e) {
      // print('裁剪出错: $e');
      if (onChanged != null) { onChanged(''); }
    }
  }
}
