import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ReusableTextVariant { h1, h2, h3, subtitle, body, caption }

class ReusableText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final double? height;
  final ReusableTextVariant variant;
  final double? fontSizeOverride;
  final TextSpan? textSpan;

  const ReusableText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.strutStyle,
    this.height,
    this.variant = ReusableTextVariant.body,
    this.fontSizeOverride,
    this.textSpan,
  });

  static Widget h1(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) =>
      ReusableText(
        text,
        key: key,
        variant: ReusableTextVariant.h1,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        height: height,
      );

  static Widget h2(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) =>
      ReusableText(
        text,
        key: key,
        variant: ReusableTextVariant.h2,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        height: height,
      );

  static Widget h3(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) =>
      ReusableText(
        text,
        key: key,
        variant: ReusableTextVariant.h3,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        height: height,
      );

  static Widget subtitle(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) =>
      ReusableText(
        text,
        key: key,
        variant: ReusableTextVariant.subtitle,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        height: height,
      );

  static Widget body(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) =>
      ReusableText(
        text,
        key: key,
        variant: ReusableTextVariant.body,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        height: height,
      );

  static Widget caption(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) =>
      ReusableText(
        text,
        key: key,
        variant: ReusableTextVariant.caption,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        height: height,
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isCaption = variant == ReusableTextVariant.caption;

    late TextStyle variantStyle;
    late FontWeight defaultWeight;

    switch (variant) {
      case ReusableTextVariant.h1:
        variantStyle = textTheme.headlineMedium ?? const TextStyle(fontSize: 30);
        defaultWeight = FontWeight.w800;
        break;
      case ReusableTextVariant.h2:
        variantStyle = textTheme.headlineSmall ?? const TextStyle(fontSize: 24);
        defaultWeight = FontWeight.w700;
        break;
      case ReusableTextVariant.h3:
        variantStyle = textTheme.titleLarge ?? const TextStyle(fontSize: 20);
        defaultWeight = FontWeight.w700;
        break;
      case ReusableTextVariant.subtitle:
        variantStyle = textTheme.titleMedium ?? const TextStyle(fontSize: 16);
        defaultWeight = FontWeight.w600;
        break;
      case ReusableTextVariant.body:
        variantStyle = textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
        defaultWeight = FontWeight.w400;
        break;
      case ReusableTextVariant.caption:
        variantStyle = textTheme.bodySmall ?? const TextStyle(fontSize: 12);
        defaultWeight = FontWeight.w400;
        break;
    }

    final baseStyle = variantStyle.copyWith(
      fontSize: fontSizeOverride?.sp ?? variantStyle.fontSize?.sp,
      fontWeight: fontWeight ?? defaultWeight,
      color: color ?? (isCaption ? scheme.onSurfaceVariant : scheme.onSurface),
      height: height ?? variantStyle.height ?? 1.35,
      fontFamily: variantStyle.fontFamily ?? 'Cairo',
    );

    final effectiveStyle = baseStyle.merge(style);

    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        softWrap: softWrap,
        style: effectiveStyle,
      );
    }

    return Text(
      text ?? '',
      textAlign: textAlign,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      maxLines: maxLines,
      softWrap: softWrap,
      strutStyle: strutStyle ?? StrutStyle(
        fontFamily: effectiveStyle.fontFamily,
        fontSize: effectiveStyle.fontSize,
        height: effectiveStyle.height,
        forceStrutHeight: true,
      ),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: true,
        applyHeightToLastDescent: true,
      ),
      style: effectiveStyle,
    );
  }
}
