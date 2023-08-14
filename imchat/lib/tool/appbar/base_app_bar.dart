import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? titleWidget;
  final String? title;
  final Color? titleColor;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;

  final double? toolbarHeight;
  final double? leadingWidth;

  final TextStyle? toolbarTextStyle;

  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool? isWhiteBack;
  final VoidCallback? onBack;
  final Shadow? arrowShadow;
  BaseAppBar({
    Key? key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.titleColor,
    this.titleWidget,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation = 0, //阴影或下划线
    this.shadowColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.isWhiteBack = false,
    this.onBack,
    this.arrowShadow,
  })  : preferredSize =
            _YCPreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          leading ??
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color(0xff1f1f1f),
              shadows: arrowShadow != null ? [arrowShadow!] : null,
            ),
            onPressed: onBack ?? () => Navigator.of(context).pop(),
          ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: titleWidget ??
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xff1f1f1f),
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
            child: Text(title ?? "",style: TextStyle(color: titleColor ?? Colors.black ),),
          ),
      actions: actions,
      bottom: bottom,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      backgroundColor: backgroundColor ?? Colors.white,
      flexibleSpace: flexibleSpace,
    );
  }
}

class _YCPreferredAppBarSize extends Size {
  _YCPreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
