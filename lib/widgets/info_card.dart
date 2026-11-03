import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Versatile information card adhering to the ALCO brand identity.
/// Provides a clean white card with subtle borders, rounded corners,
/// and optional icon, trailing action, and tap callbacks.
class InfoCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final Widget? trailing;
  final Widget? customContent;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const InfoCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.trailing,
    this.customContent,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.appBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: icon!,
                ),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 6.0),
                      Text(
                        description!,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.0,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8.0),
                trailing!,
              ],
            ],
          ),
          if (customContent != null) ...[
            const SizedBox(height: 12.0),
            customContent!,
          ],
        ],
      ),
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
          child: cardContent,
        ),
      ),
    );
  }
}

