import 'dart:io';
import 'package:dio/dio.dart';
import 'package:base_project/utils/public.dart';

/// 请求参数
class HttpConfig {
  // static String baseUrl = isDebugMode ? 'https://test.dzm.com/' : 'https://build.dzm.com/';
  static const connectTimeout = 60;
  static const receiveTimeout = 60;
  static const contentType = 'application/json; charset=utf-8';
  static const accept = 'application/json,*/*';
  static String platform = Platform.isAndroid ? 'android' : 'ios';
}

/// 请求类型
enum HttpMethod {
  get(value: 'GET'),
  post(value: 'POST'),
  postFormData(value: 'POST');

  final String value;
  const HttpMethod({ required this.value });
}

/// 响应对象
class HttpResponse<T> {
  /// 状态码
  int? code;
  /// 数据
  T? data;
  /// 消息
  String? msg;
  /// 成功的定义
  bool get isSuccess {
    return (code == 0);
  }
}

/// 签名对象
// class HttpSignature<T> {
//   String? sign;
//   String? nonce;
//   int? timestamp;
// }

class HttpManager {

  /// dio 对象
  late Dio _dio;

  /// 单例
  static final HttpManager _instance = HttpManager.init();
  factory HttpManager() => _instance;

  /// 单例初始化
  HttpManager.init() {
    // 公共头部
    Map<String, String> headers = {
      'Accept': HttpConfig.accept,
      'ContentType': HttpConfig.contentType,
      'Authorization': '',
      'platform': HttpConfig.platform,
    };
    // 公共配置
    final options = BaseOptions(
      // 如果确定项目在同一个环境下，只会使用一个域名，可以设置这个；
      // 如果同一环境可能存在多个域名，不要配置这个，到请求位置单独配置；
      // baseUrl: HttpConfig.baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: HttpConfig.connectTimeout),
      receiveTimeout: const Duration(seconds: HttpConfig.receiveTimeout),
      responseType: ResponseType.json,
      contentType: HttpConfig.contentType,
    );
    /// 初始化Dio对象
    _dio = Dio(options);
    /// 各种拦截器
    // if (isDebugMode) {}
  }

  /// 公共请求
  Future<HttpResponse> request({
    // 请求地址
    required String url,
    // 请求类型
    required HttpMethod method,
    // 请求参数
    Map<String, dynamic>? parameters,
    // 请求头（会自行合并公共请求头）
    Map<String, dynamic>? headers,
    // 过滤错误码，默认会显示错误，可传入需要过滤的错误码，在外面进行判断显示错误
    List<int>? filterErrorCodes,
    // 是否 toast 显示 then 回调的非 0 错误信息
    bool showThenToast = true,
    // 是否 toast 显示 catch 回调的错误信息
    bool showCatchToast = true,
  }) async {
    // 请求配置
    Options options = Options(method: method.value, headers: headers ?? {});
    // 响应对象57
    HttpResponse httpResponse = HttpResponse();
    // 添加token
    _dio.options.headers['Authorization'] = accountModel.accessToken ?? '';
    // 根据请求类型处理参数
    Object? data;
    Map<String, dynamic>? queryParameters;
    switch (method) {
      case HttpMethod.get:
        queryParameters = parameters;
        break;
      case HttpMethod.post:
        data = parameters;
        break;
      case HttpMethod.postFormData:
        if (parameters != null) { data = FormData.fromMap(parameters); }
        break;
    }
    // 请求地址
    // final reqUrl = url.startsWith('http') ? url : HttpConfig.baseUrl + url;
    String baseUrl = isDebugMode! ? 'https://test.dzm.com/' : 'https://build.dzm.com/';
    String reqUrl = url.startsWith('http') ? url : baseUrl + url;
    // 请求处理
    try {
      // 发起请求
      final dioResponse = await _dio.request(
        reqUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      // 如果返回的数据是 String，先转成 JSON
      var responseData = dioResponse.data;
      if (responseData is String) {
        // 转换为 Map<String, dynamic>
        responseData = jsonEncodeCustom(responseData);
      }
      // 同步参数
      try {
        httpResponse.code = responseData?['code'] ?? dioResponse.statusCode;
        httpResponse.data = responseData?['data'];
        httpResponse.msg = responseData?['message'] ?? dioResponse.statusMessage;
      } catch (e) {
        httpResponse.code = -1;
        httpResponse.data = responseData;
        httpResponse.msg = '未知错误';
      }
      // 错误码过滤
      if (filterErrorCodes != null && filterErrorCodes.contains(httpResponse.code)) {
        // 不做处理
      } else {
        // 失败直接提示错误
        if (showThenToast && httpResponse.code != 0) {
          hud.showToast(httpResponse.msg!);
        }
      }
      // 记录日志
      if (logs.isEnable) {
        logs.add({
          logs.keyTitle: '${method.value} $url',
          logs.keySuccess: httpResponse.code == 0,
          'parameters': method == HttpMethod.get ? queryParameters : (method == HttpMethod.postFormData ? parameters.toString() : data),
          'headers': {...headers ?? {}, ..._dio.options.headers},
          logs.keyData: dioResponse.data
        });
      }
    } on DioException catch (e) {
      // 记录日志
      if (logs.isEnable) {
        logs.add({
          logs.keyTitle: '${method.value} $url',
          logs.keySuccess: false,
          'parameters': method == HttpMethod.get ? queryParameters : (method == HttpMethod.postFormData ? parameters.toString() : data),
          'headers': {...headers ?? {}, ..._dio.options.headers},
          logs.keyData: e.toString()
        });
      }
      // 隐藏加载
      hud.dismiss();
      // 错误信息
      if (e.response != null) {
        // 记录参数
        httpResponse.code = e.response?.statusCode;
        httpResponse.data = e.response?.data;
        httpResponse.msg = e.response?.statusMessage;
        // 错误码过滤
        if (filterErrorCodes != null && filterErrorCodes.contains(httpResponse.code)) {
          // 不做处理
        } else {
          // 针对错误信息处理
          if (e.response?.statusCode == 401) {
            // 登录已过期
            // hud.showToast('登录已过期，请重新登录');
            logout();
          } else if (e.response?.statusCode == 403) {
            // 账号已限制登录
            hud.showToast('账号已限制登录，请联系客服');
            logout();
          } else {
            // 其他错误
            if (showCatchToast) {
              hud.showToast('当前系统繁忙，请稍后再试，感谢您的理解');
            }
          }
        }
      } else {
        // 未知错误
        httpResponse.code = -1;
        httpResponse.msg = '未知错误';
      }
    }
    // 返回
    return httpResponse;
  }

  /// Get 请求
  /// [parameters] 请求参数
  Future<HttpResponse> get({
    required String url,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    List<int>? filterErrorCodes,
    bool showThenToast = true,
    bool showCatchToast = true,
  }) {
    return request(
      url: url,
      method: HttpMethod.get,
      parameters: parameters,
      headers: headers,
      showThenToast: showThenToast,
      showCatchToast: showCatchToast,
    );
  }

  /// Post 请求
  Future<HttpResponse> post({
    required String url,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    List<int>? filterErrorCodes,
    bool showThenToast = true,
    bool showCatchToast = true,
  }) {
    return request(
      url: url,
      method: HttpMethod.post,
      parameters: parameters,
      headers: headers,
      showThenToast: showThenToast,
      showCatchToast: showCatchToast,
    );
  }

  /// Post 请求（上传文件）
  Future<HttpResponse> postFormData({
    required String url,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    List<int>? filterErrorCodes,
    bool showThenToast = true,
    bool showCatchToast = true,
  }) {
    return request(
      url: url,
      method: HttpMethod.postFormData,
      parameters: parameters,
      headers: headers,
      showThenToast: showThenToast,
      showCatchToast: showCatchToast,
    );
  }
}
