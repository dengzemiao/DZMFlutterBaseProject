import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';
import 'package:base_project/utils/constant.dart';

class CustomAlert {

  /// 显示弹窗
  static Future<void> showWidget({
    /// 上下文
    required BuildContext context,
    /// 是否禁止点击背景关闭弹框
    bool? barrierDismissible,
    /// 弹窗内容
    Widget? child,
  }) {
    return showDialog(
      context: context,
      // 禁止点击背景关闭弹框
      barrierDismissible: barrierDismissible ?? false,
      builder: (BuildContext context) {
        return PopScope(
          // 允许物理返回键
          canPop: barrierDismissible ?? false,
          child: Dialog(
            // 弹框的“外部”空隙，避免弹出框紧贴屏幕边缘，不设置有默认值，如果想弹窗宽点可以设置
            // insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: child
          )
        );
      },
    );
  }

  /// 显示弹窗
  static Future<void>  show({
    /// 上下文
    required BuildContext context,
    /// 内容
    String? text,
    /// 描述
    String? desc,
    /// 图标
    String? icon,
    /// 整体宽度
    double? width,
    /// 整体高度
    double? height,
    /// 自定义内容区域
    Widget? widget,
    /// 自定义内容区域内边距
    EdgeInsets? widgetMargin,
    /// 自定义描述内容区域
    Widget? descWidget,
    /// 确认文案
    String? confirmText,
    /// 取消文案
    String? cancelText,
    /// 取消是否隐藏
    bool? hideCancel,
    /// 是否禁止点击背景关闭弹框
    bool? barrierDismissible,
    /// 回调
    ValueChanged<bool>? onConfirm,
    /// 回调，自行实现隐藏遮罩
    ValueChanged<bool>? onConfirmPro
  }) {
    void onPressed (bool value) {
      if (onConfirm != null) {
        Future.delayed(Duration.zero, () {
          onConfirm(value);
        });
      }
      if (onConfirmPro != null) {
        Future.delayed(Duration.zero, () {
          onConfirmPro(value);
        });
      } else {
        Navigator.pop(context);
      }
    }

    return showWidget(
      context: context,
      barrierDismissible: barrierDismissible,
      child: InkWell(
        onTap: () => barrierDismissible == true ? Navigator.pop(context) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width ?? adaptSize(320),
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(adaptSize(8)),
              ),
              child: Column(
                children: [
                  // 内容
                  Padding(
                    padding: widgetMargin ?? EdgeInsets.all(adaptSize(20)),
                    child: widget ?? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 图标
                        if (icon != null)
                          ...[
                            Image.asset(icon, width: adaptSize(64), height: adaptSize(64)),
                            SizedBox(height: adaptSize(12)),
                          ],
                        // 标题
                        Text(text ?? '', style: TextStyle(fontSize: adaptFontSize(14), color: const Color(0xFF323233), fontWeight: FontWeight.w500)),
                        // 描述
                        if (descWidget != null)
                          descWidget,
                        if (descWidget == null && desc != null)
                          ...[
                            SizedBox(height: adaptSize(8)),
                            Text(desc, style: TextStyle(fontSize: adaptFontSize(12), color: const Color(0xFFA8A8A8))),
                          ],
                      ]
                    ),
                  ),
                  // 分割线
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: const Color(0xFF000000).withOpacity(0.1),
                  ), 
                  // 操作
                  SizedBox(
                    width: double.infinity,
                    height: adaptSize(48),
                    child: Row(
                      children: [
                        if (hideCancel != true)
                          ...[
                            // 取消
                            Expanded(
                              child: InkWell(
                                onTap: () => onPressed(false),
                                child: Center(child: Text(cancelText ?? '取 消', style: TextStyle(color: const Color(0xFF576B95), fontSize: adaptFontSize(14))))
                              )
                            ),
                            // 分割线
                            Container(
                              width: 0.5,
                              height: double.infinity,
                              color: const Color(0xFF000000).withOpacity(0.1),
                            ), 
                          ],                   
                        // 确定
                        Expanded(
                          child: InkWell(
                            onTap: () => onPressed(true),
                            child: Center(child:  Text(confirmText ?? '确 定', style: TextStyle(color: primaryColor, fontSize: adaptFontSize(14))))
                          )
                        )
                      ]
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      )
    );
  }
}

/// 自定义底部回调
typedef CustomBottomSheetCallback = void Function(int index);

class CustomBottomSheet {

  /// 显示弹窗
  static Future<void> showWidgetBox({
    /// 上下文
    required BuildContext context,
    /// 标题文案
    String? title,
    /// 弹窗内容
    Widget? child,
    /// 背景颜色
    Color? backgroundColor,
    /// 最大高度
    double? maxHeight
  }) {
    return CustomBottomSheet.showWidget(
      context: context,
      title: title,
      backgroundColor: backgroundColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // 设置最大高度
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              child ?? Container()
            ],
          )
        )
      )
    );
  }

  /// 显示弹窗
  static Future<void> showWidget({
    /// 上下文
    required BuildContext context,
    /// 标题文案
    String? title,
    /// 弹窗内容
    Widget? child,
    /// 背景颜色
    Color? backgroundColor,
  }) {
    return CustomBottomSheet.show(
      context: context,
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          if (title != null)
            Container(
              width: double.infinity,
              height: adaptSize(50),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 1, color: const Color(0xFFF1F3F7).withOpacity(0.5))
                )
              ),
              alignment: Alignment.center,
              child: Text(title, style: TextStyle(color: const Color(0xFF000000), fontSize: adaptFontSize(14))),
            ),
          // 内容
          child ?? Container()
        ]
      )
    );
  }

  /// 显示弹窗
  static Future<void> show({
    /// 上下文
    required BuildContext context,
    /// 取 title 字段展示，其他随意
    List<String>? list,
    /// 取消文案
    String? cancelText,
    /// 自定义弹窗
    Widget? child,
    /// 背景颜色
    Color? backgroundColor,
    /// 回调
    CustomBottomSheetCallback? onConfirm,
    /// 回调，自行实现隐藏遮罩
    CustomBottomSheetCallback? onConfirmPro
  }) {
    void onTopItem (int index, String item) {
      if (onConfirm != null) {
        Future.delayed(Duration.zero, () {
          onConfirm(index);
        });
      }
      if (onConfirmPro != null) {
        Future.delayed(Duration.zero, () {
          onConfirmPro(index);
        });
      } else {
        Navigator.pop(context);
      }
    }
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(adaptSize(8)),
              topRight: Radius.circular(adaptSize(8)),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(adaptSize(8)),
              topRight: Radius.circular(adaptSize(8)),
            ),
            child: child ?? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (list != null && list.isNotEmpty)
                  ...[
                    ...list.asMap().map((index, item) {
                      return MapEntry(index, Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: adaptSize(56),
                            child: InkWell(
                              onTap: () => onTopItem(index, item),
                              child: Center(
                                child: Text(item, style: TextStyle(color: const Color(0xFF000000), fontSize: adaptFontSize(14))),
                              ),
                            ),
                          ),
                          // 分割线
                          if (index != list.length - 1)  // 防止最后一项后面有分割线
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: const Color(0xFFF2F2F2),
                            ),
                        ],
                      ));
                    }).values,
                    // 分割线
                    Container(
                      width: double.infinity,
                      height: adaptSize(8),
                      color: const Color(0xFFF2F2F2),
                    ),
                  ],
                // 取消
                SizedBox(
                  width: double.infinity,
                  height: adaptSize(56),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Text('取消', style: TextStyle(color: const Color(0xFF000000), fontSize: adaptFontSize(14))),
                    )
                  )
                ),
                // 空白
                SizedBox(height: getBottomSafeAreaHeight(context))
              ]
            ),
          )
        );
      },
    );
  }
}