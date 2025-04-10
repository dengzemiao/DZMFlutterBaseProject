import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base_project/utils/public.dart';
import 'code_button.dart';

/// 尾部图标模式
enum CustomInputFieldSuffixMode {
  
  /// 无，纯展示
  none(value: 'none'),
  /// 密码
  pwd(value: 'pwd'),
  /// 验证码
  code(value: 'code');

  /// value
  final String value;
  const CustomInputFieldSuffixMode({ required this.value });
}

class CustomInputField extends StatefulWidget {
  /// 宽度
  final double? width;
  /// 高度
  final double? height;
  /// 内间距
  final EdgeInsets? padding;
  /// 圆角
  final BorderRadius? borderRadius;
  /// 背景颜色
  final Color backgroundColor;
  /// 前缀图片路径
  final String prefixImagePath;
  /// 后缀图片路径
  final String suffixImagePath;
  /// 输入文本样式
  final TextStyle? textStyle;
  /// 提示文本
  final String hintText;
  /// 提示文本样式
  final TextStyle? hintStyle;
  /// 内容边距
  final EdgeInsetsGeometry? contentPadding;
  /// 键盘类型
  final TextInputType? keyboardType;
  /// 最大长度
  final int? maxLength;
  /// 使用模糊内容
  final bool obscureText;
  /// 图标尺寸
  final double? imageSize;
  /// 图标间距 
  final double? imageSpacing;
  /// 禁止输入空格
  final bool disableSpaces;
  /// 只能数字
  final bool onlyDigits;
  /// 允许清空
  final bool allowClear;
  /// 清空视图
  final Widget? clearWidget;
  /// 倒计时的秒数
  final int seconds;
  /// 控制器
  final TextEditingController? controller;
  /// 聚焦节点
  final FocusNode? focusNode;
  /// 允许验证码点击
  final bool allowCodeTap;
  /// 后缀模式
  final CustomInputFieldSuffixMode suffixMode;
  /// 清空回调
  final ValueChanged<String>? onClear;
  /// 输入变化的回调函数
  final ValueChanged<String>? onChanged;
  /// 回车
  final ValueChanged<String>? onSubmitted;
  /// 获取验证码
  final VoidCallback? onGetCode;
  /// 点击后缀图标
  final VoidCallback? onSuffixClicked;

  const CustomInputField({
    super.key,
    this.width = double.infinity,
    this.height,
    this.padding,
    this.borderRadius,
    this.backgroundColor = Colors.white,
    this.prefixImagePath = '',
    this.suffixImagePath = '',
    this.textStyle,
    this.hintText = '请输入',
    this.hintStyle,
    this.contentPadding,
    this.keyboardType,
    this.maxLength,
    this.imageSize,
    this.imageSpacing,
    this.disableSpaces = true,
    this.onlyDigits = false,
    this.allowClear = false,
    this.clearWidget,
    this.seconds = 60,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.allowCodeTap = false,
    this.suffixMode = CustomInputFieldSuffixMode.none,
    this.onClear,
    this.onChanged,
    this.onSubmitted,
    this.onGetCode,
    this.onSuffixClicked,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {

  /// 文案是否隐藏
  late bool _obscureText;
  /// 允许清空
  late bool _allowClear;
  /// 宽度
  final double width = double.infinity;
  /// 高度
  final double height = adaptSize(50);
  /// 内间距
  final EdgeInsets padding = EdgeInsets.symmetric(horizontal: adaptSize(16));
  /// 圆角
  final BorderRadius borderRadius = BorderRadius.circular(adaptSize(8.0));
  /// 图标尺寸
  final double imageSize = adaptSize(20);
  /// 图标间距
  final double imageSpacing = adaptSize(8);
  /// 输入文本样式
  final TextStyle textStyle = TextStyle(fontSize: adaptFontSize(13));
  /// 提示文本样式
  final TextStyle hintStyle = TextStyle(fontSize: adaptFontSize(13), color: const Color(0xFFC8C9CC));
  /// 清空图标大小
  final double clearImageWidth = adaptSize(20);
  /// 清高图标尺寸
  final double clearSize = adaptSize(14);
  /// 验证码宽度
  final double codeWidth = adaptSize(100);
  /// 验证码高度
  final double codeHeight = adaptSize(32);

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _allowClear = false;
    // 监听
    if (widget.controller != null) {
      widget.controller!.addListener(_onTextEditingChanged);
    }
  }

  @override
  void dispose() { 
    if (widget.controller != null) {
      widget.controller!.removeListener(_onTextEditingChanged);
    }
    super.dispose();
  }

  // 监听
  void _onTextEditingChanged () {
    _onChanged(widget.controller!.text);
  }

  /// 点击后缀图标
  void _onSuffixClicked () {
    // 根据类型进行处理
    if (widget.suffixMode == CustomInputFieldSuffixMode.pwd) {
      // 切换密码显示状态
      setState(() {
        _obscureText = !_obscureText;
      });
    }
    // 调用回调函数
    if (widget.onSuffixClicked != null) {
      widget.onSuffixClicked!();
    }
  }

  /// 输入变化
  void _onChanged (String value) {
    if (widget.allowClear) {
      setState(() {
        _allowClear = value.isNotEmpty;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  /// 清空
  void _clear () {
    if (widget.controller != null) {
      widget.controller!.clear();
      _onChanged(widget.controller!.text);
    }
    if (widget.onClear != null) {
      widget.onClear!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? width,
      height: widget.height ?? height,
      padding: widget.padding ?? padding,
      decoration: BoxDecoration(
        // 背景色
        color: widget.backgroundColor,
        // 圆角半径
        borderRadius: widget.borderRadius ?? borderRadius,
      ),
      child: Row(
        children: [
          // 前缀图标
          if (widget.prefixImagePath.isNotEmpty) 
            ...[
              Image.asset(
                widget.prefixImagePath,
                width: widget.imageSize ?? imageSize,
                height: widget.imageSize ?? imageSize,
              ),
              SizedBox(width: widget.imageSpacing ?? imageSpacing),
            ],
          // 输入框
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLines: 1,
              focusNode: widget.focusNode,
              onChanged: _onChanged,
              onSubmitted: widget.onSubmitted,
              maxLength: widget.maxLength,
              style: widget.textStyle ?? textStyle,
              obscureText: _obscureText,
              // keyboardType: widget.onlyDigits ? TextInputType.number : widget.keyboardType,
              keyboardType: widget.keyboardType,
              inputFormatters: [
                // 只允许数字
                if (widget.onlyDigits) FilteringTextInputFormatter.digitsOnly,
                // 禁止空格
                if (widget.disableSpaces) FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              decoration: InputDecoration(
                // 提示文本
                hintText: widget.hintText,
                // 提示文本样式
                hintStyle: widget.hintStyle ?? hintStyle,
                // 去掉边框
                border: InputBorder.none,
                // 隐藏计数器
                counterText: '',
                // 内容内边距
                contentPadding: widget.contentPadding,
              ),
            ),
          ),
          // 清除按钮
          if (widget.allowClear && _allowClear)
            ...[
              // SizedBox(width: widget.imageSpacing ?? imageSpacing),
              widget.clearWidget ?? InkWell(
                onTap: _clear,
                child: SizedBox(
                  width: clearImageWidth,
                  height: double.infinity,
                  child: Icon(
                    Icons.cancel,
                    size: clearSize,
                    color: const Color(0xFFC8C9CC),
                  ),
                )
              )
            ],
          // 后缀图标
          if (widget.suffixMode == CustomInputFieldSuffixMode.none && widget.suffixImagePath.isNotEmpty) 
            ...[
              SizedBox(width: widget.imageSpacing ?? imageSpacing),
              InkWell(
                onTap: _onSuffixClicked,
                child: Image.asset(
                  widget.suffixImagePath,
                  width: widget.imageSize ?? imageSize,
                  height: widget.imageSize ?? imageSize,
                ),
              ),
            ],
          if (widget.suffixMode == CustomInputFieldSuffixMode.pwd) 
            ...[
              SizedBox(width: widget.imageSpacing ?? imageSpacing),
              if (_obscureText)
                InkWell(
                  onTap: _onSuffixClicked,
                  child: Image.asset(
                    'assets/images/image_pwd_hide.png',
                    width: widget.imageSize ?? imageSize,
                    height: widget.imageSize ?? imageSize,
                  )
                )
              else
                InkWell(
                  onTap: _onSuffixClicked,
                  child: Image.asset(
                    'assets/images/image_pwd_show.png',
                    width: widget.imageSize ?? imageSize,
                    height: widget.imageSize ?? imageSize,
                  )
                )
            ],
          if (widget.suffixMode == CustomInputFieldSuffixMode.code) 
            ...[
              SizedBox(width: widget.imageSpacing ?? imageSpacing),
              SizedBox(
                width: codeWidth,
                height: codeHeight,
                child: CodeButton(
                  allowTap: widget.allowCodeTap,
                  seconds: widget.seconds,
                  onTap: widget.onGetCode
                )
              )
            ]
        ],
      ),
    );
  }
}
