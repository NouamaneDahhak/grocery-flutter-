import 'dart:async';
import 'package:delivery/models/data_models/order_product_items.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsDetails extends StatefulWidget {
  final StreamController<bool> controller;
  final List<OrdersProductItem> products;

  ItemsDetails({required this.controller,required this.products});



  @override
  _ItemsDetailsState createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    final themeModel=Provider.of<ThemeModel>(context);

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      vsync: this,
      child: StreamBuilder<bool>(
          stream: widget.controller.stream,
          initialData: false,
          builder: (context, snapshot) {
            return Column(
              children: [
                Container(
                  height: 0.5,
                  color: themeModel.secondTextColor,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart_outlined,
                    color: themeModel.textColor,
                  ),
                  title: Texts.headline3(
                      "Items", themeModel.textColor),
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
                    ? FadeIn(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        ///Items
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10),
                          child: Texts.subheads(
                              '${widget.products.length} item' +
                                  ((widget.products.length ==
                                      1)
                                      ? ""
                                      : "s"),
                              themeModel.textColor),
                        ),
                        Column(
                          children: List.generate(
                              widget.products.length,
                                  (position) {
                                return Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width / 3,
                                      child: Texts.subheads(
                                          widget.products[position]
                                              .title,
                                          themeModel.textColor),
                                    ),
                                    Container(
                                      width: width / 3,
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Texts.text(
                                          widget.products[position]
                                              .quantity,
                                          themeModel
                                              .secondTextColor),
                                    ),
                                    Container(
                                      alignment:
                                      Alignment.centerRight,
                                      width: width / 3 - 40,
                                      child: Texts.subheads(
                                          widget.products[position]
                                              .price
                                              .toString() +
                                              "\$",
                                          themeModel.priceColor),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                )
                    : SizedBox()
              ],
            );
          }),
    );
  }
}

