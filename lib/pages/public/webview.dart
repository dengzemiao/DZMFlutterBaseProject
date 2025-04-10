import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:base_project/components/app_bar.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';

class WebviewController extends StatefulWidget {

  /// 导航标题（传入则不会获取网页标题）
  final String? title;
  /// url
  final String? url;

  const WebviewController({
    super.key,
    this.title,
    this.url
  });

  @override
  WebviewControllerState createState() => WebviewControllerState();
}

class WebviewControllerState extends State<WebviewController> {

  /// 标题
  late String _title;
  /// url
  late String _url;
  /// 固定标题
  late bool _fixedTitle;
  /// WebViewController
  late WebViewController _webViewController;
  /// 背景颜色
  late Color? backgroundColor = primaryBgColor;

  @override
  void initState() {
    super.initState();
    // 获取标题
    _title = widget.title ?? nav.parameters['title'] ?? '';
    // 有值则固定标题
    _fixedTitle = _title.isNotEmpty;
    // 获取 url
    _url = widget.url ?? nav.parameters['url'] ?? '';
    // 初始化
    initWebView(_url);
  }
  
  @override
  void dispose() {
    // 清除缓存
    _webViewController.clearCache();
    // 清除本地存储
    _webViewController.clearLocalStorage();
    super.dispose();
  }

  void initWebView(String url) {
    try {
      // WebViewController 初始化
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            // onProgress: (int progress) {
            //   log("加载进度: $progress%");
            // },
            onPageStarted: (String url) {
              // log("页面开始加载: $url");
              if (!_fixedTitle) {
                setState(() { _title = '　'; });
              }
            },
            onPageFinished: (String url) {
              // log("页面加载完成: $url");
              _fetchPageTitle();
            },
            // onHttpError: (HttpResponseError error) {
            //   log("HTTP 错误 ${error} - ${error.response?.statusCode} - ${error.request?.uri}");
            // },
            onWebResourceError: (WebResourceError error) {
              // log("网页资源加载错误, ${error} - ${error.errorCode} - ${error.description}");
              _fetchPageTitle();
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(_url));
        // 设置背景颜色
        _webViewController.setBackgroundColor(backgroundColor ?? Colors.white);
    } catch (_) {}
  }

  /// 获取网页标题
  Future<void> _fetchPageTitle() async {
    if (!_fixedTitle) {
      try {
        final title = await _webViewController.runJavaScriptReturningResult('document.title');
        setState(() { _title = title as String; });
      } catch (e) {
        log('获取网页标题失败: $e');
      }
    }
  }

  /// 左侧返回
  void onLeftCallback () async {
    // 如果 WebView 有历史记录，返回上一页
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
    } else {
      nav.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 自定义导航栏
         CustomAppBar(title: _title, onLeftCallback: onLeftCallback),
          // 页面内容
          Expanded(
            child: WebViewWidget(controller: _webViewController),
          )
        ]
      ),
    );
  }
}