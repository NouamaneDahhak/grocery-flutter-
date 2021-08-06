import 'dart:async';
import 'package:delivery/blocs/order_details_bloc.dart';
import 'package:delivery/models/data_models/address.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddressDetails extends StatefulWidget {
  final StreamController<bool> controller;
  final Address address;

  AddressDetails({required this.controller, required this.address});

  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      vsync: this,
      child: StreamBuilder<bool>(
        stream: widget.controller.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 0.5,
                color: themeModel.secondTextColor,
              ),
              ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: themeModel.textColor,
                ),
                title:
                    Texts.headline3("Shipping address", themeModel.textColor),
                onTap: () {
                  widget.controller.add(!snapshot.data!);
                },
                contentPadding:
                    EdgeInsets.only(right: 20, bottom: 5, top: 5, left: 20),
                trailing: Icon(
                  (!snapshot.data!)
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: themeModel.textColor,
                ),
              ),
              (snapshot.data!)
                  ? Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: FadeIn(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Full name
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'Full name:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(widget.address.name,
                                  themeModel.secondTextColor),
                            ),
                            ///Address
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'Address:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(widget.address.address,
                                  themeModel.secondTextColor),
                            ),
                            ///City
                            (widget.address.city != null)
                                ? Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Texts.subheads(
                                        'City:', themeModel.textColor),
                                  )
                                : SizedBox(),
                            (widget.address.city != null)
                                ? Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Texts.text(widget.address.city!,
                                        themeModel.secondTextColor),
                                  )
                                : SizedBox(),
                            ///State
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'State:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(widget.address.state,
                                  themeModel.secondTextColor),
                            ),
                            ///Zip code
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'Zip code:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(widget.address.zipCode,
                                  themeModel.secondTextColor),
                            ),
                            ///Coutry
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'Country:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(widget.address.country,
                                  themeModel.secondTextColor),
                            ),
                            ///Phone
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'Phone:', themeModel.textColor),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Texts.text(widget.address.phone,
                                      themeModel.secondTextColor),
                                ),
                                Spacer(),
                                IconButton(
                                    icon: Icon(
                                      Icons.copy,
                                      color: themeModel.secondTextColor,
                                    ),
                                    onPressed: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: widget.address.phone));
                                      Fluttertoast.showToast(
                                          msg: "Number copied!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }),
                              ],
                            ),
                            ///Show map
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: GestureDetector(
                                  child: Column(
                                    children: [
                                      FadeIn(
                                        child: SvgPicture.asset(
                                          'images/map.svg',
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Texts.subheads('Show In Map',
                                            themeModel.accentColor),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    final bloc = Provider.of<OrderDetailsBloc>(
                                        context,
                                        listen: false);

                                    await bloc.showMap(widget.address);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          );
        },
      ),
    );
  }
}
