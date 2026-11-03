import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Custom App Bar widget adhering to the ALCO brand identity.
/// Provides consistent header styling with optional back and action controls.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final bool showBottomBorder;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.centerTitle = false,
    this.bottom,
    this.showBottomBorder = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    if (showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.mainText,
        tooltip: 'Kembali',
        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      );
    }

    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: leadingWidget,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.mainText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      bottom: bottom ??
          (showBottomBorder
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(
                    color: AppColors.border,
                    height: 1.0,
                  ),
                )
              : null),
    );
  }
}
