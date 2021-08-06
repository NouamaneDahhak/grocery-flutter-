import 'package:delivery/models/state_models/bottom_navigation_bar_model.dart';
import 'package:delivery/models/state_models/home_model.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:flutter/material.dart';
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
              Icons.home_outlined,
              color: (model.indexPage == 0)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Products"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: (model.indexPage == 1)
                  ? Color(0xFF7BED8D)
                  : Color(0xFFA6BCD0),
            ),
            label: "Settings"),
      ],
    );
  }
}
