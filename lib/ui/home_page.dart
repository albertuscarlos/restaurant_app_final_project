import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/common/style.dart';
import 'package:flutter_restaurant_app/provider/bottom_nav_provider.dart';
import 'package:flutter_restaurant_app/ui/favorites_page.dart';
import 'package:flutter_restaurant_app/ui/restaurant_list_page.dart';
import 'package:flutter_restaurant_app/ui/settings_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, bottomNavProvider, child) {
        return Scaffold(
          body: _menuList[bottomNavProvider.bottomNavIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: _bottomNavBarItems,
            selectedItemColor: bottomNavColor,
            currentIndex: bottomNavProvider.bottomNavIndex,
            onTap: (value) {
              bottomNavProvider.bottomNav(value);
            },
          ),
        );
      },
    );
  }

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.restaurant_menu,
      ),
      label: 'Restaurant',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite,
      ),
      label: 'Favorites',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
      ),
      label: 'Settings',
    ),
  ];

  final List<Widget> _menuList = [
    const RestaurantListPage(),
    const FavoritesPage(),
    const SettingsPage(),
  ];
}
