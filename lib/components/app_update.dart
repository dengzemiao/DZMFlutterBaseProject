import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';
import 'package:base_project/model/app_update.dart';
import './alert.dart';

class AppUpdate {
  static void show({
    /// 上下文
    required BuildContext context,
    /// 更新信息
    required AppUpdateModel model,
  }) {
    void onPressed (bool value) {
      if (!value) {
        Navigator.pop(context);
      }
      if (value && model.downloadUrl != null) {
        nav.open(model.downloadUrl);
      }
    }
    CustomAlert.showWidget(
      context: context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/image_bg_14.png',
            width: double.infinity,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: adaptSize(22)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(adaptSize(18)),
                bottomRight: Radius.circular(adaptSize(18)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title ?? '', style: TextStyle(color: const Color(0xFF333333), fontSize: adaptFontSize(16))),
                SizedBox(height: adaptSize(12)),
                Text(model.desc ?? '', style: TextStyle(color: const Color(0xFF8F8F8F), fontSize: adaptFontSize(13), height: 2)),
                SizedBox(height: adaptSize(20)),
                Row(
                  children: [
                    // 稍后提醒
                    if (!(model.forcedUpdate != null && model.forcedUpdate == 1))
                      ...[
                        Expanded(
                          child: InkWell(
                            onTap: () => onPressed(false),
                            child: Container(
                              height: adaptSize(40),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.all(Radius.circular(adaptSize(8)))
                              ),
                              child: Center(
                                child: Text('稍后提醒', style: TextStyle(color: const Color(0xFF656972), fontSize: adaptFontSize(14)))
                              )
                            )
                          )
                        ),
                        SizedBox(width: adaptSize(10)), 
                      ],                
                    // 立即更新
                    Expanded(
                      child: InkWell(
                        onTap: () => onPressed(true),
                        child: Container(
                          height: adaptSize(40),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(adaptSize(8)))
                          ),
                          child: Center(
                            child: Text('立即更新', style: TextStyle(color: Colors.white, fontSize: adaptFontSize(14)))
                          )
                        )
                      )
                    ),
                  ],
                ),
                SizedBox(height: adaptSize(22))
              ],
            )
          ),
          SizedBox(height: adaptSize(24)),
        ],
      ),
    );
  }
}
