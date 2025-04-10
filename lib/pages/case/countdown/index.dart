import 'package:flutter/material.dart';
import 'package:base_project/base/stateful/index.dart';
// import 'package:base_project/utils/public.dart';
import 'package:base_project/components/countdown.dart';

class CountdownController extends BaseStatefulController {

  const CountdownController({super.key, super.title});

  @override
  CountdownControllerState createState() => CountdownControllerState();
}

class CountdownControllerState extends BaseStatefulControllerState {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int timestamp = 1737780593; // 时间戳（秒）
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    print(dateTime1); // 输出：2025年1月25日 04:49:53

    int timestampInMilliseconds = 1737780593000; // 时间戳（毫秒）
    DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
    print(dateTime2); // 输出：2025年1月25日 04:49:53

    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Countdown(
              targetTime: DateTime.now(),
              onComplete: () => print('倒计时结束0'),
            ),
            Countdown(
              targetTime: DateTime.now().add(const Duration(seconds: 15)),
              onComplete: () => print('倒计时结束1'),
            ),
            Countdown(
              targetTime: DateTime.now().add(const Duration(minutes: 15)),
              onComplete: () => print('倒计时结束2'),
            ),
            Countdown(
              targetTime: DateTime.now().add(const Duration(hours: 2)),
              onComplete: () => print('倒计时结束3'),
            ),
            Countdown(
              targetTime: DateTime.now().add(const Duration(hours: 2, seconds: 15)),
              onComplete: () => print('倒计时结束4'),
            ),
            Countdown(
              targetTime: dateTime2,
              onComplete: () => print('倒计时结束5'),
            )
          ]
        )
      )
    );
  }
}