import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';

class AnimateController extends BaseStatefulController {

  const AnimateController({ super.key, super.title });

  @override
  AnimateControllerState createState() => AnimateControllerState();
}

class AnimateControllerState extends BaseStatefulControllerState {

  // 控制容器是否扩展
  bool isExpanded = false;

  @override
  Widget? buildBody(BuildContext context) {
    return Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500), // 动画持续时间
              curve: Curves.easeInOut, // 动画曲线
              width: isExpanded ? MediaQuery.of(context).size.width : 200, // 容器宽度
              height: isExpanded ? MediaQuery.of(context).size.height : 200, // 容器高度
              color: isExpanded ? Colors.blue : Colors.red, // 容器颜色
              child: Center(
                child: Text(
                  isExpanded ? "全屏容器" : "点击扩展",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded; // 切换状态
                });
              },
              child: Icon(
                isExpanded ? Icons.close : Icons.fullscreen, // 切换图标
              ),
            ),
          ),
        ],
      );
  }
}
