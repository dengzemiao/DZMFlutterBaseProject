import 'package:dio/dio.dart';
import 'package:base_project/utils/public.dart';
import '../utils/request.dart';

class AppRequest {
  
  // 静态变量存储单例
  static final AppRequest _instance = AppRequest._internal();
  // 静态方法获取单例实例
  factory AppRequest() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  AppRequest._internal();
  
  /// ============================================= 公共

  /// 检查APP版本
  Future<HttpResponse> checkVersion([Map<String, dynamic>? parameters]) {
    return HttpManager().get(
      url: '/api/about/check-version',
      parameters: parameters,
      showThenToast: false,
      showCatchToast: false,
    );
  }

  /// 获取验证码
  Future<HttpResponse> sendSms([Map<String, dynamic>? parameters]) {
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    double checkcode = 0;
    return HttpManager().post(
      url: '/api/auth/sms',
      parameters: parameters,
      headers: {
        'X-Timestamp': timestamp,
        'X-Check-Code': checkcode.truncate()
      },
    );
  }

  /// ============================================= 登录

  /// 登录
  Future<HttpResponse> login([Map<String, dynamic>? parameters]) {
    return HttpManager().post(
      url: '/api/auth/login',
      parameters: parameters
    );
  }

  /// 退出登录
  Future<HttpResponse> logout([Map<String, dynamic>? parameters]) {
    return HttpManager().post(
      url: '/api/auth/logout',
      parameters: parameters,
    );
  }

  /// 重设密码
  Future<HttpResponse> resetPassword([Map<String, dynamic>? parameters]) {
    return HttpManager().post(
      url: '/api/auth/reset-password',
      parameters: parameters,
    );
  }

  /// 删除账户
  Future<HttpResponse> delete([Map<String, dynamic>? parameters]) {
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    double checkcode =  (timestamp - 1369245318) * 2.19 + ((parameters?['mobile'] ?? 0) - 13800138000) * 3.18 + (parameters?['sms_code'] ?? 0) * 318.219 + 666;
    return HttpManager().post(
      url: '/api/auth/delete',
      parameters: parameters,
      headers: {
        'X-Timestamp': timestamp,
        'X-Check-Code': checkcode.truncate()
      },
    );
  }

  /// ============================================= 首页

  /// 获取首页Banner列表
  Future<HttpResponse> homeBanners([Map<String, dynamic>? parameters]) {
    return HttpManager().get(
      url: '/api/home/banners',
      parameters: parameters,
    );
  }

  /// ============================================= 个人信息
  
  /// 获取个人信息
  Future<HttpResponse> userInfo([Map<String, dynamic>? parameters]) {
    return HttpManager().get(
      url: '/api/profile/profile',
      parameters: parameters
    );
  }
  
  /// 更新个人信息
  Future<HttpResponse> userInfoUpdate([Map<String, dynamic>? parameters]) {
    return HttpManager().post(
      url: '/api/profile/update',
      parameters: parameters
    );
  }

  /// 获取个人积分余额
  Future<HttpResponse> userPoint([Map<String, dynamic>? parameters]) {
    return HttpManager().get(
      url: '/api/profile/point',
      parameters: parameters,
      showThenToast: false,
      showCatchToast: false,
    );
  }

  /// ============================================= 上传文件

  /// oss 上传文件
  Future<HttpResponse?> ossUpload(String filePath) async {
    // 发起网络请求
    final tokenResponse = await ossToken();
    // 成功
    if (tokenResponse.code == 0) {
      // token 数据
      final tokenData = tokenResponse.data;
      // 文件名
      final fileName = generateFileName(filePath, tokenData['dir']);
      // 上传文件
      final uploadResponse = await ossUploadBase({
        'success_action_status': '200',
        'OSSAccessKeyId': tokenData['accessid'],
        'policy': tokenData['policy'],
        'signature': tokenData['signature'],
        'callback': tokenData['callback'],
        'key': fileName,
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      // 返回结果
      return uploadResponse;
    }
    // 返回空
    return null;
  }
  
  /// oss 获取上传 token
  Future<HttpResponse> ossToken([Map<String, dynamic>? parameters]) {
    return HttpManager().post(
      url: '/api/common/oss-token',
      parameters: parameters
    );
  }

  /// oss 上传文件
  Future<HttpResponse> ossUploadBase([Map<String, dynamic>? parameters]) {
    return HttpManager().postFormData(
      url: 'https://edu-aixinghe.oss-cn-shanghai.aliyuncs.com/',
      parameters: parameters
    );
  }
}