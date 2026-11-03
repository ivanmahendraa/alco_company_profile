import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Bottom navigation bar component adhering to the ALCO brand identity.
/// Provides access to the three primary app destinations:
/// 1. Beranda
/// 2. Perusahaan
/// 3. Berita
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.accentLime.withAlpha(60),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.primaryGreen,
                size: 24.0,
              );
            }
            return const IconThemeData(
              color: AppColors.secondaryText,
              size: 24.0,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          elevation: 0,
          height: 64.0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
              tooltip: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business),
              label: 'Perusahaan',
              tooltip: 'Perusahaan',
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper_outlined),
              selectedIcon: Icon(Icons.newspaper),
              label: 'Berita',
              tooltip: 'Berita',
            ),
          ],
        ),
      ),
    );
  }
}
