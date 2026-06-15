import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kantin_digital/core/constants/app_colors.dart';

class KantinMainLayout extends StatelessWidget {
  final Widget child;
  const KantinMainLayout({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/pos/check-card')) {
      return 1;
    } else if (location.startsWith('/pos/products')) {
      return 2;
    } else if (location.startsWith('/pos/sales')) {
      return 3;
    }
    return 0; // default to /pos
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/pos');
        break;
      case 1:
        context.go('/pos/check-card');
        break;
      case 2:
        context.go('/pos/products');
        break;
      case 3:
        context.go('/pos/sales');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.cardBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textGray,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2, size: 22),
              activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill, size: 22),
              label: 'Kasir',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.creditcard, size: 22),
              activeIcon: Icon(CupertinoIcons.creditcard_fill, size: 22),
              label: 'Cek Kartu',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.tray_full, size: 22),
              activeIcon: Icon(CupertinoIcons.tray_full_fill, size: 22),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.time, size: 22),
              activeIcon: Icon(CupertinoIcons.time_solid, size: 22),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}
