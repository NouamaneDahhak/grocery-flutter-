import 'package:flutter/material.dart';
import 'package:grocery_admin/models/state_models/bottom_navigation_bar_model.dart';
import 'package:grocery_admin/models/state_models/home_model.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarHome extends StatelessWidget {
  final BottomNavigationBarModel model;

  BottomNavigationBarHome({required this.model});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return BottomNavigationBar(
      onTap: (index) {
        model.goToPage(index);

        final homeModel = Provider.of<HomeModel>(context, listen: false);
        homeModel.goToPage(index);
      },
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(color: themeModel.accentColor),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.store_outlined,
              color: (model.indexPage == 0)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Products"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.local_shipping_outlined,
              color: (model.indexPage == 1)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Shipping"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer_outlined,
              color: (model.indexPage == 2)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Coupons"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: (model.indexPage == 3)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Orders"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: (model.indexPage == 4)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Settings"),
      ],
    );
  }
}
