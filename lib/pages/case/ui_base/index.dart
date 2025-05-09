import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
import 'package:base_project/utils/public.dart';

class UiBaseController extends BaseStatefulController {

  const UiBaseController({super.key, super.title});

  @override
  UiBaseControllerState createState() => UiBaseControllerState();
}

class UiBaseControllerState extends BaseStatefulControllerState {
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,  // 设置背景色
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 设置为水平方向滚动
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent, // 设置为透明，如果不想改变背景色
                        child: InkWell(
                          onTap: () {
                            // 按钮点击后的操作
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            // color: Colors.orange, // 设置背景颜色
                            child: const Text('Custom Button1'),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.green, // 设置背景颜色
                        child: InkWell(
                          onTap: () {
                            // 按钮点击后的操作
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              'Custom Button2',
                              style: TextStyle(color: Colors.white), // 设置文字颜色
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(child: const Text('ElevatedButton'), onPressed: () {}),
                      TextButton(child: const Text('TextButton'), onPressed: () {}),
                      OutlinedButton(child: const Text('OutlinedButton'), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
                      FloatingActionButton(child: const Icon(Icons.add), onPressed: () {}),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          // 处理用户选择的选项
                        },
                        itemBuilder: (BuildContext context) {
                          return {'Option 1', 'Option 2', 'Option 3'}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                      DropdownButton<String>(
                        value: 'Option 1',
                        onChanged: (String? newValue) {
                          // 处理选中的项
                        },
                        items: <String>['Option 1', 'Option 2', 'Option 3']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          // 按钮点击后的操作
                        },
                        shape: const CircleBorder(),
                        fillColor: Colors.blue,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.access_alarm, color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          // 按钮点击后的操作
                        },
                        color: Colors.green,
                        child: const Text('Material Button'),
                      )
                    ],
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Card Example"),
                  ),
                ),
                Container(
                  color: Colors.yellow,
                  height: adaptHeight(100),
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Text("Align Example"),
                  )
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(adaptSize(16)),
                    child: const Text("DecoratedBox Example"),
                  ),
                ),
                Wrap(
                  spacing: 8, // 设置水平方向（主轴）上的子组件之间的间距
                  runSpacing: 8, // 设置垂直方向（换行时，纵轴）上的子组件之间的间距
                  children: [
                    Container(width: 50, height: 50, color: Colors.red),
                    Container(width: 50, height: 50, color: Colors.green),
                    Container(width: 50, height: 50, color: Colors.yellow),
                    Container(width: 50, height: 50, color: Colors.red),
                    Container(width: 50, height: 50, color: Colors.green),
                    Container(width: 50, height: 50, color: Colors.yellow),
                    Container(width: 50, height: 50, color: Colors.red),
                    Container(width: 50, height: 50, color: Colors.green),
                    Container(width: 50, height: 50, color: Colors.yellow),
                    Container(width: 50, height: 50, color: Colors.red),
                    Container(width: 50, height: 50, color: Colors.green),
                    Container(width: 50, height: 50, color: Colors.yellow),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset('assets/images/a_temp.png'),
                ),
                const Text('Home Page', style: TextStyle(fontSize: 24, backgroundColor: Colors.red)),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Padding - padding', style: TextStyle( backgroundColor: Colors.orange, color: Colors.black),),
                      Text('Row 1', style: TextStyle(fontSize: 24, backgroundColor: Colors.green, color: Colors.black),),
                      SizedBox(width: 20), // 设置固定间距
                      Text('Row 2', style: TextStyle(fontSize: 24, backgroundColor: Colors.red, color: Colors.black),),
                      Spacer(), // 自动占据主轴上的剩余空间，在组件之间创建间距。
                      Text('Row 3', style: TextStyle(fontSize: 24, backgroundColor: Colors.yellow, color: Colors.black),),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Row(
                    children: [
                      Text('Container - padding', style: TextStyle( backgroundColor: Colors.orange, color: Colors.black),),
                      Text('Row 1', style: TextStyle(fontSize: 24, backgroundColor: Colors.green, color: Colors.black),),
                      Text('Row 2', style: TextStyle(fontSize: 24, backgroundColor: Colors.red, color: Colors.black),),
                      Text('Row 3', style: TextStyle(fontSize: 24, backgroundColor: Colors.yellow, color: Colors.black),),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: const Row(
                    children: [
                      Text('Container - margin', style: TextStyle( backgroundColor: Colors.orange, color: Colors.black),),
                      Text('Row 1', style: TextStyle(fontSize: 24, backgroundColor: Colors.green, color: Colors.black),),
                      Text('Row 2', style: TextStyle(fontSize: 24, backgroundColor: Colors.red, color: Colors.black),),
                      Text('Row 3', style: TextStyle(fontSize: 24, backgroundColor: Colors.yellow, color: Colors.black),),
                  ]),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Row 1', style: TextStyle(fontSize: 24, backgroundColor: Colors.green, color: Colors.black),),
                    Text('Row 2', style: TextStyle(fontSize: 24, backgroundColor: Colors.red, color: Colors.black),),
                    Text('Row 3', style: TextStyle(fontSize: 24, backgroundColor: Colors.yellow, color: Colors.black),),
                ]),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Row 1', style: TextStyle(fontSize: 24, backgroundColor: Colors.green, color: Colors.black),),
                    Text('Row 2', style: TextStyle(fontSize: 24, backgroundColor: Colors.red, color: Colors.black),),
                    Text('Row 3', style: TextStyle(fontSize: 24, backgroundColor: Colors.yellow, color: Colors.black),),
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,  // 占据1份空间
                        child: Container(color: Colors.red, height: 50),
                      ),
                      Flexible(
                        flex: 1,  // 占据1份空间
                        child: Container(color: Colors.orange, height: 50),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,  // 占据2份空间
                        child: Container(color: Colors.red, height: 50),
                      ),
                      Flexible(
                        flex: 1,  // 占据1份空间
                        child: Container(color: Colors.orange, height: 50),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,  // 占据2份空间
                        child: Container(color: Colors.red, height: 50),
                      ),
                      const Text('测试内容'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Expanded 默认 flex = 1
                      Expanded(
                        child: Container(color: Colors.red, height: 50),
                      ),
                      Expanded(
                        child: Container(color: Colors.yellow, height: 50),
                      ),
                      Expanded(
                        child: Container(color: Colors.green, height: 50),
                      )
                    ],
                  ),
                ),
                // 根据屏幕尺寸自动调整布局
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return const Row(
                        children: [Text('根据屏幕尺寸自动调整布局 Wide layout')],
                      );
                    } else {
                      return const Column(
                        children: [Text('根据屏幕尺寸自动调整布局 Narrow layout')],
                      );
                    }
                  },
                )
              ],
            ),
          )
        )
      ),
    );
  }
}