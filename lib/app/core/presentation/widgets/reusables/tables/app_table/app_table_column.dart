import 'package:flutter/material.dart';

/// كلاس تعريف العمود في الجدول التفاعلي الذكي [ReusableTable].
class ReusableTableColumn<T> {
  final String id;
  final String title;
  final Widget Function(T item)? cellBuilder;
  final String Function(T item)? textBuilder;
  final String Function(T item)? searchValueGetter;
  final String Function(List<T> items)? summaryTextBuilder;
  final Widget Function(List<T> items)? summaryCellBuilder;
  final double? width;
  final double? minWidth;
  final double? maxWidth;
  final int flex;
  final AlignmentGeometry? alignment;
  final bool isSortable;
  final bool isNumeric;
  final bool isVisible;
  final bool isSearchable;
  final String? tooltip;
  final EdgeInsetsGeometry? cellPadding;
  final Widget? emptyCellWidget;

  const ReusableTableColumn({
    required this.id,
    required this.title,
    this.cellBuilder,
    this.textBuilder,
    this.searchValueGetter,
    this.summaryTextBuilder,
    this.summaryCellBuilder,
    this.width,
    this.minWidth,
    this.maxWidth,
    this.flex = 0,
    this.alignment,
    this.isSortable = false,
    this.isNumeric = false,
    this.isVisible = true,
    this.isSearchable = true,
    this.tooltip,
    this.cellPadding,
    this.emptyCellWidget,
  });

  ReusableTableColumn<T> copyWith({
    String? id,
    String? title,
    Widget Function(T item)? cellBuilder,
    String Function(T item)? textBuilder,
    String Function(T item)? searchValueGetter,
    String Function(List<T> items)? summaryTextBuilder,
    Widget Function(List<T> items)? summaryCellBuilder,
    double? width,
    double? minWidth,
    double? maxWidth,
    int? flex,
    AlignmentGeometry? alignment,
    bool? isSortable,
    bool? isNumeric,
    bool? isVisible,
    bool? isSearchable,
    String? tooltip,
    EdgeInsetsGeometry? cellPadding,
    Widget? emptyCellWidget,
  }) {
    return ReusableTableColumn<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      textBuilder: textBuilder ?? this.textBuilder,
      searchValueGetter: searchValueGetter ?? this.searchValueGetter,
      summaryTextBuilder: summaryTextBuilder ?? this.summaryTextBuilder,
      summaryCellBuilder: summaryCellBuilder ?? this.summaryCellBuilder,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      flex: flex ?? this.flex,
      alignment: alignment ?? this.alignment,
      isSortable: isSortable ?? this.isSortable,
      isNumeric: isNumeric ?? this.isNumeric,
      isVisible: isVisible ?? this.isVisible,
      isSearchable: isSearchable ?? this.isSearchable,
      tooltip: tooltip ?? this.tooltip,
      cellPadding: cellPadding ?? this.cellPadding,
      emptyCellWidget: emptyCellWidget ?? this.emptyCellWidget,
    );
  }
}
