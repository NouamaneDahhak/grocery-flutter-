import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_admin/models/state_models/settings_model.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/ui/home/categories/categories.dart';
import 'package:grocery_admin/ui/home/delivery_boys/delivery_boys.dart';
import 'package:grocery_admin/ui/home/settings/update_info.dart';
import 'package:grocery_admin/ui/home/settings/upload_image.dart';
import 'package:grocery_admin/widgets/cards.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:grocery_admin/widgets/transparent_image.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {

  final SettingsModel model;

  Settings._({required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);

    return ChangeNotifierProvider<SettingsModel>(
        create: (context)=>SettingsModel(auth:auth,database:database),
      child: Consumer<SettingsModel>(
        builder: (context,model,_){
          return Settings._(model: model);
        },
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width=MediaQuery.of(context).size.width;


    print(model.displayName);
    return Scaffold(

      body: ListView(
        children: [

          ///Profile information
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30,
                      offset: Offset(0, 5),
                      color: themeModel.shadowColor)
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    UploadImage.create(context).then((value) {
                      if (value ?? false) {
                        model.updateWidget();
                      }
                    });

                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FadeInImage(
                      placeholder:  MemoryImage(kTransparentImage),
                      image: (model.profileImage != null)
                          ? NetworkImage(model.profileImage!)
                          : AssetImage('images/profile.png') as ImageProvider,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UpdateInfo.create(context).then((value) {
                      if (value != null) {
                        model.updateWidget();
                      }
                    });

                  },
                  child: Container(
                    width: width - 148,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Texts.headline3(
                              model.displayName, themeModel.textColor),
                        ),
                        Texts.text(model.email, themeModel.secondTextColor),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    UpdateInfo.create(context).then((value) {
                      if (value != null) {
                        model.updateWidget();
                      }
                    });

                  },


                  icon: Icon(Icons.edit, color: themeModel.textColor,),

                ),
              ],
            ),
          ),

          GridView.count(
              crossAxisCount: (width ~/ 120),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 80),
              children: [

               

                Cards.settings(context, title: "Categories", onPressed: (){

                  Categories.create(context);

                }, widget: FadeIn(
                  child: SvgPicture.asset('images/category.svg',
                  height: (width * 0.5) / (width ~/ 60),
                  ),


                ),
                color: themeModel.textColor
                ),


                Cards.settings(context, title: "Delivery", onPressed: (){

                  DeliveryBoys.create(context);


                }, widget: FadeIn(
                  child: SvgPicture.asset('images/delivery_boy.svg',
                    height: (width * 0.5) / (width ~/ 60),
                  ),


                ),
                color: themeModel.textColor,
                ),






                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: themeModel.secondBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              offset: Offset(0, 5),
                              color: themeModel.shadowColor)
                        ]),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Texts.descriptiveItems('Dark mode', themeModel.textColor,
                                textOverflow: TextOverflow.ellipsis, maxLines: 1,
                                alignment: TextAlign.center
                            ),
                          ),
                          Switch(
                            activeColor: themeModel.accentColor,
                            value: themeModel.theme.brightness == Brightness.dark,
                            onChanged: (value) {
                              themeModel.updateTheme();
                            },
                          )

                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    themeModel.updateTheme();

                  },
                ),

                Cards.settings(context, title: "Logout", onPressed: ()async{

                 await model.signOut();


                },
                    widget: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: (width * 0.5) / (width ~/ 60),
                    ),
                  color: Colors.red
                )






              ]
          ),
        ],
      ),
      );


      /*ListView(
        children: [
          ///Dark mode switch
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),

            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            //   padding: EdgeInsets.all(20),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              onTap: () {
                themeModel.updateTheme();
              },
              leading: Icon(
                Icons.star_border,
                color: themeModel.accentColor,
              ),
              title: Texts.text('Dark mode', themeModel.textColor),
              trailing: Switch(
                activeColor: themeModel.accentColor,
                value: themeModel.theme.brightness == Brightness.dark,
                onChanged: (value) {
                  themeModel.updateTheme();
                },
              ),
            ),
          ),

          ///Logout button
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),

            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
            //   padding: EdgeInsets.all(20),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              onTap: () async {
                await model.signOut();
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Texts.text('Logout', themeModel.textColor),
            ),
          ),
        ],
      ),

       */

  }
}
