import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/ui/home/home_page/deliveries.dart';
import 'package:delivery/ui/home/home_page/history.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: themeModel.shadowColor,
          title: Texts.headline3('Home', themeModel.textColor),
          centerTitle: true,
          backgroundColor: themeModel.secondBackgroundColor,
          leading: Container(),
          actions: [],
          bottom: TabBar(
            tabs: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Texts.subheads('Processing', themeModel.secondTextColor),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Texts.subheads('History', themeModel.secondTextColor),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ///Deliveries
            Deliveries.create(context),

            ///History
            History.create(context),
          ],
        ),
      ),
    );
  }
}
