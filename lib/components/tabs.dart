import 'package:flutter/material.dart';
import 'package:base_project/utils/public.dart';

/// Tab 宽度模式
enum TabWidthMode {
  
  /// 各用各的宽度（默认）
  none(value: 'none'),
  /// 全部使用 normal 的宽度
  normal(value: 'normal'),
  /// 全部使用 selected 的宽度
  selected(value: 'selected'),
  ;

  /// value
  final String value;
  const TabWidthMode({ required this.value });
}

class Tabs extends StatefulWidget {

  /// Tab 标题列表
  final List<String> tabs;
  /// Tab 标题样式
  final TextStyle normalStyle;
  /// 选中的 Tab 标题样式
  final TextStyle selectedStyle;
  /// 选中的索引
  final int selectedIndex;
  /// Tab 之间的间距
  final double tabSpacing;
  /// 动画时间
  final int milliseconds;
  /// 隐藏滑块
  final bool hideSlider;
  /// Tab 宽度模式
  final TabWidthMode tabWidthMode;
  /// 滑块高度
  final double sliderHeight;
  /// 滑块颜色
  final Color sliderColor;
  /// 切换事件
  final ValueChanged<int>? onChanged;

  const Tabs({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.tabSpacing = 10,
    this.milliseconds = 200,
    this.normalStyle = const TextStyle(color: Colors.black),
    this.selectedStyle = const TextStyle(color: Colors.blue),
    this.hideSlider = false,
    this.sliderHeight = 2.0,
    this.sliderColor = Colors.blue,
    this.tabWidthMode = TabWidthMode.none,
    this.onChanged,
  });

  @override
  State<Tabs> createState() => TabsState();
}

class TabsState extends State<Tabs> {
  int _selectedIndex = 0;

  // 保存每个 Tab 的默认宽度和选中状态下的宽度
  late List<Map<String, double>> _tabWidths;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _calculateTabWidths();
  }

  void _calculateTabWidths() {
    _tabWidths = widget.tabs.map((tab) => {
      'normal': calcTextWidth(text: tab, style: widget.tabWidthMode == TabWidthMode.selected ? widget.selectedStyle : widget.normalStyle, extraWidth: adaptSize(5)),
      'selected': calcTextWidth(text: tab, style: widget.tabWidthMode == TabWidthMode.normal ? widget.normalStyle : widget.selectedStyle, extraWidth: adaptSize(5)),
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: List.generate(
            widget.tabs.length,
            (index) {
              return Row(
                children: [
                  _buildTabButton(index, widget.tabs[index]),
                  if (index != widget.tabs.length - 1)
                    SizedBox(width: widget.tabSpacing),
                ],
              );
            },
          ),
        ),
        if (!widget.hideSlider)
          AnimatedPositioned(
            duration: Duration(milliseconds: widget.milliseconds),
            left: _calculateSliderPosition(),
            bottom: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: widget.milliseconds),
              width: _tabWidths[_selectedIndex]['selected']!,
              height: widget.sliderHeight,
              color: widget.sliderColor,
            ),
          ),
      ],
    );
  }

  double _calculateSliderPosition() {
    double position = 0;
    for (int i = 0; i < _selectedIndex; i++) {
      position += _tabWidths[i]['normal']! + widget.tabSpacing;
    }
    return position;
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedIndex == index;
    final tabWidth = _tabWidths[index][isSelected ? 'selected' : 'normal']!;
    final textStyle = isSelected ? widget.selectedStyle : widget.normalStyle;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(index);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.milliseconds),
        width: tabWidth,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: widget.milliseconds),
            style: textStyle,
            softWrap: false,
            child: Text(
              label,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }
}
