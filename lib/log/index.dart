import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:base_project/base/scroll/index.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';

class LogController extends BaseScrollController {

  const LogController({super.key});

  @override
  LogControllerState createState() => LogControllerState();
}

class LogControllerState extends BaseScrollControllerState {

  @override
  void initState() {
    super.initState();
    // 重新进入清空
    logs.enableDevCounter = 0;
    // 进入了日志页面
    logs.isInTheLogPage = true;
  }

  @override
  void dispose() { 
    super.dispose();
    // 离开了日志页面
    logs.isInTheLogPage = false;
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
      // 获取设备信息
      final deviceInfo = await DeviceInfoPlugin().deviceInfo;
      setState(() {
        logs.add({
          logs.keyTitle: '设备信息',
          logs.keyData: deviceInfo.toString()
        });
      });
      // 获取应用信息
      final info = await PackageInfo.fromPlatform();
      setState(() {
        logs.add({
          logs.keyTitle: '应用信息',
          logs.keyData: info.toString()
        });
      });
      // 其他信息
      setState(() {
        // 获取运行模式
        logs.add({
          logs.keyTitle: '运行模式',
          logs.keyData: {
            'debug': kDebugMode,
            'release': kReleaseMode,
            'profile': kProfileMode,
          }
        });
        // 添加当前环境
        logs.add({
          logs.keyTitle: '当前环境：${isDebugMode! ? '测试' : '正式'}',
          logs.keyData: {'isDebugMode': isDebugMode}
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
                          // 切换日志开关次数计数器
                          logs.enableDevCounter += 1;
                          // 检查数量次数是否达到
                          if (logs.enableDevCounter % logs.enableDevCounterNumber == 0) {
                            // 切换环境
                            isDebugMode = !isDebugMode!;
                            // 存储环境
                            storage.setBool(PublicKey.debugMode.value, isDebugMode!);
                            // 直接退出登录
                            logout(() {
                              nav.offAllNamed(appRoutes.initialRoute);
                            });
                            // 强行开启日志
                            logs.enable(true, context: context);
                            // 添加日志
                            logs.add({logs.keyTitle: '当前环境：${isDebugMode! ? '测试' : '正式'}', logs.keyData: {'isDebugMode': isDebugMode}});
                            // 提示
                            hud.showToast('当前环境：${isDebugMode! ? '测试' : '正式'}');
                          } else {
                            // 切换状态
                            logs.enable(!logs.isEnable, context: context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(child: Text('${logs.isEnable ? '关闭' : '开启'}日志', style: const TextStyle(color: Colors.white)))
                        ),
                      )
                    ),
                    // 清空日志
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            logs.clear();
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
                          child: const Center(child: Text('设备、应用、环境信息', style: TextStyle(color: Colors.white)))
                        ),
                      )
                    ),
                    // 用户信息
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            logs.add({
                              logs.keyTitle: '用户信息',
                              logs.keyData: accountModel.toJson()
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: const Center(child: Text('用户信息', style: TextStyle(color: Colors.white)))
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
                            logs.isExpanded = !logs.isExpanded;
                            // 便利状态
                            for (int i = 0; i < logs.logs.length; i++) {
                              logs.logs[i]['expand'] = logs.isExpanded;
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(child: Text('${logs.isExpanded ? '收起' : '展开'}全部日志', style: const TextStyle(color: Colors.white)))
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
              Map<String, dynamic> log = logs.logs[index];
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
                                    hud.showToast('复制成功');
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
                                      maxLines: 2,
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
            childCount: logs.logs.length,
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