import 'dart:async';
import 'package:delivery/models/data_models/coupon.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponDetails extends StatefulWidget {
  final StreamController<bool> controller;
  final Coupon coupon;

  CouponDetails({required this.controller, required this.coupon});

  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails>
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
              ListTile(
                leading: Icon(
                  Icons.local_offer,
                  color: themeModel.textColor,
                ),
                title: Texts.headline3("Coupon", themeModel.textColor),
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
                            ///Coupon code
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child:
                                  Texts.subheads('Code:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(widget.coupon.code,
                                  themeModel.secondTextColor),
                            ),
                            ///Coupon value
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Texts.subheads(
                                  'Value:', themeModel.textColor),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Texts.text(
                                  widget.coupon.value.toString() +
                                      ((widget.coupon.type == 'percentage')
                                          ? "%"
                                          : "\$"),
                                  themeModel.priceColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              Container(
                height: 0.5,
                color: themeModel.secondTextColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
