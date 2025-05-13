import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:base_project/base/scroll/index.dart';
import 'package:base_project/utils/public.dart';
import './logs.dart';
import '../utils/hud.dart';
import '../../model/account.dart';

class LogController extends BaseScrollController {

  const LogController({super.key});

  @override
  LogControllerState createState() => LogControllerState();
}

class LogControllerState extends BaseScrollControllerState {

  // 日志对象
  final _logs = Logs();

  @override
  void initState() {
    super.initState();
    // 重新进入清空
    _logs.enableDevCounter = 0;
    // 进入了日志页面
    _logs.isInTheLogPage = true;
  }

  @override
  void dispose() { 
    super.dispose();
    // 离开了日志页面
    _logs.isInTheLogPage = false;
  }

  @override
  Widget? buildAppBar(BuildContext context, String? title) {
    return super.buildAppBar(context, '日志');
  }

  /// json 格式化
  String jsonFormat(Object? object) => const JsonEncoder.withIndent('  ').convert(object);

  /// 复制内容
  Future<void> copy (String? text) async {
    await Clipboard.setData(ClipboardData(text: text ?? ''));
  }

  /// 设备、应用信息
  void onAppInfo () async {
    try {
      // 获取运行模式
      setState(() {
        _logs.add({
          _logs.keyTitle: '运行模式',
          _logs.keyData: {
            'debug': kDebugMode,
            'release': kReleaseMode,
            'profile': kProfileMode,
          }
        });
      });
      // 获取应用信息
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _logs.add({
          _logs.keyTitle: '应用信息',
          _logs.keyData: info.toString()
        });
      });
      // 获取设备信息
      final deviceInfo = await DeviceInfoPlugin().deviceInfo;
      setState(() {
        _logs.add({
          _logs.keyTitle: '设备信息',
          _logs.keyData: deviceInfo.toString()
        });
      });
    } catch (_) {}
  }

  @override
  Widget? buildScrollView(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // 功能栏
        // SliverPersistentHeader(
        //   // 保持在顶部
        //   pinned: true,
        //   // 悬浮内容
        //   delegate: LogSliverHeaderDelegate(
        //     // // 传递点击事件回调
        //     onTap: () {
        //     }
        //   )
        // ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              children: [
                // 一行
                Row(
                  children: [
                    // 开关日志
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // 切换日志开关次数计数器
                            _logs.enableDevCounter += 1;
                            // 检查数量次数是否达到
                            if (_logs.enableDevCounter % _logs.enableDevCounterNumber == 0) {
                              // 判断切换环境
                              String debugTypeString = '';
                              if (debugType == 0) {
                                // 当前系统环境切换到测试环境
                                debugTypeString = '测试环境';
                                debugType = 1;
                              } else if (debugType == 1) {
                                // 当前测试环境切换到正式环境
                                debugTypeString = '正式环境';
                                debugType = 2;
                              } else if (debugType == 2) {
                                // 当前正式环境切换到测试环境
                                debugTypeString = '测试环境';
                                debugType = 1;
                              }
                              // 直接退出登录
                              logout(() {
                                nav.offAllNamed(appRoutes.initialRoute);
                              });
                              // 强行开启日志
                              _logs.enable(true, context: context);
                              // 添加日志
                              _logs.add({
                                _logs.keyTitle: '当前接口环境 - $debugTypeString',
                                _logs.keyData: debugType
                              });
                              // 提示
                              Hud().showToast('当前接口环境已切换为 $debugTypeString');
                              // 不执行后续代码了
                              return;
                            }
                            // 切换状态
                            _logs.enable(!_logs.isEnable, context: context);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(child: Text('${_logs.isEnable ? '关闭' : '开启'}日志', style: const TextStyle(color: Colors.white)))
                        ),
                      )
                    ),
                    // 清空日志
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _logs.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: const Center(child: Text('清空日志', style: TextStyle(color: Colors.white)))
                        ),
                      )
                    )
                  ],
                ),
                // 一行
                const SizedBox(height: 14),
                Row(
                  children: [
                    // 设备信息
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onAppInfo();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: const Center(child: Text('输出设备、应用信息', style: TextStyle(color: Colors.white)))
                        ),
                      )
                    ),
                    // 用户信息
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _logs.add({
                              _logs.keyTitle: '用户信息',
                              _logs.keyData: AccountModel().toJson()
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: const Center(child: Text('输出用户信息', style: TextStyle(color: Colors.white)))
                        ),
                      )
                    )
                  ],
                ),
                // 一行
                const SizedBox(height: 14),
                Row(
                  children: [
                    // 开关日志
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // 切换状态
                            _logs.isExpanded = !_logs.isExpanded;
                            // 便利状态
                            for (int i = 0; i < _logs.logs.length; i++) {
                              _logs.logs[i]['expand'] = _logs.isExpanded;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(child: Text('${_logs.isExpanded ? '收起' : '展开'}全部日志', style: const TextStyle(color: Colors.white)))
                        ),
                      )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // 列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              Map<String, dynamic> log = _logs.logs[index];
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: log['expand'] ? Colors.transparent : Colors.white,
                  ))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 日志标题
                    Container(
                      width: double.infinity,
                      color: log['success'] ? Colors.green : Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          // 时间
                          Padding(
                            padding: const EdgeInsets.only(left: 2, right: 10),
                            child: Row(
                              children: [
                                // 标题
                                Expanded(
                                  child: Text(
                                    '【${log['index']}】${log['date']}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                // 复制
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    copy(jsonFormat(log));
                                    Hud().showToast('复制成功');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(4))
                                    ),
                                    child: const Text('复制', style: TextStyle(color: Colors.black, fontSize: 12))
                                  ),
                                ),
                                // 展开、收起
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      log['expand'] = !log['expand'];
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(4))
                                    ),
                                    child: Text(log['expand'] ? '收起' : '展开', style: const TextStyle(color: Colors.black, fontSize: 12))
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 标题
                          if (!log['expand'])
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  // 标题
                                  Expanded(
                                    child: Text(
                                      '${log['title']}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ]
                              )
                            )
                        ],
                      )
                    ),
                    // 日志内容
                    if (log['expand'])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: SelectableText(jsonFormat(log)),
                      )
                  ],
                ),
              );
            },
            childCount: _logs.logs.length,
          ),
        ),
      ]
    );
  }
}

// SliverPersistentHeaderDelegate
// class LogSliverHeaderDelegate extends SliverPersistentHeaderDelegate {

//   final VoidCallback onTap;

//   LogSliverHeaderDelegate({required this.onTap});

//   @override
//   double get maxExtent => 200.0;
//   @override
//   double get minExtent => 50.0;

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return InkWell(
//       onTap: onTap, // 添加点击事件
//       child: Container(
//         color: Colors.orange,
//         alignment: Alignment.center,
//         child: const Center(child: Text('Custom Header'))
//       ),
//     );
//   }

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }