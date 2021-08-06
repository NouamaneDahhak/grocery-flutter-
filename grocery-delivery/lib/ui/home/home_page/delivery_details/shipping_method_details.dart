import 'dart:async';
import 'package:delivery/models/data_models/shipping_method.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingMethodDetails extends StatefulWidget {


  final StreamController<bool> controller;
  final ShippingMethod shippingMethod;

  ShippingMethodDetails({required this.controller,required this.shippingMethod});

  @override
  _ShippingMethodDetailsState createState() => _ShippingMethodDetailsState();
}

class _ShippingMethodDetailsState extends State<ShippingMethodDetails> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {

    final themeModel=Provider.of<ThemeModel>(context);
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
                  Icons.local_shipping_outlined,
                  color: themeModel.textColor,
                ),
                title: Texts.headline3(
                    "Shipping method", themeModel.textColor),
                onTap: () {
                  widget.controller.add(!snapshot.data!);
                },
                contentPadding: EdgeInsets.only(
                    right: 20, bottom: 5, top: 5, left: 20),
                trailing: Icon(
                  (!snapshot.data!)
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: themeModel.textColor,
                ),
              ),
              (snapshot.data!)
                  ? Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, bottom: 20),
                child: FadeIn(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      ///Shipping title
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Texts.subheads(
                            'Shipping title:',
                            themeModel.textColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Texts.text(
                            widget.shippingMethod.title,
                            themeModel.secondTextColor),
                      ),
                      ///Shipping price
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Texts.subheads(
                            'Price:', themeModel.textColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Texts.text(
                            widget.shippingMethod.price
                                .toString() +
                                "\$",
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
