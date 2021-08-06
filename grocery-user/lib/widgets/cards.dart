import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/blocs/addresses_bloc.dart';
import 'package:grocery/models/data_models/address.dart';
import 'package:grocery/models/data_models/cart_item.dart';
import 'package:grocery/models/data_models/category.dart';
import 'package:grocery/models/data_models/product.dart';
import 'package:grocery/models/state_models/theme_model.dart';
import 'package:grocery/ui/addresses/add_address.dart';
import 'package:grocery/ui/home/cart/edit_cart_item.dart';
import 'package:grocery/ui/products_reader.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:grocery/widgets/transparent_image.dart';
import 'package:provider/provider.dart';
import 'package:decimal/decimal.dart';

import 'buttons.dart';

/// All Cards used in the App
class Cards {
  static Widget product(
      {required ThemeModel themeModel,
      required Product product,
      required double width,
      required void Function() onTap}) {
    return GestureDetector(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: product.reference,
                child: FadeInImage(
                  height: (width * 0.5) / (width ~/ 180),
                  image: NetworkImage(product.image),
                  placeholder: MemoryImage(kTransparentImage),
                )),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Texts.text(product.title, themeModel.textColor,
                  textOverflow: TextOverflow.ellipsis, maxLines: 1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: GestureDetector(
                child: Texts.text(
                    "${(product.pricePerKg == null) ? product.pricePerPiece : product.pricePerKg}\$",
                    themeModel.priceColor),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  static Widget category(
    BuildContext context, {
    required Category category,
  }) {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        ProductReader.create(context, category: category.title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeModel.shadowColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: EdgeInsets.only(right: 20),
        width: 180,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInImage(
              width: 100,
              height: 100,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(category.image),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Texts.text(
                  category.title.replaceFirst(
                      category.title[0], category.title[0].toUpperCase()),
                  themeModel.textColor),
            )
          ],
        ),
      ),
    );
  }

  static Widget cart(BuildContext context,
      {required CartItem cartItem,
      required Future Function() delete,
      required Future Function(String, int) updateQuantity,
      required Future Function(String, String) updateUnit,
      required void Function() goToProduct}) {
    final themeModel = Provider.of<ThemeModel>(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          color: themeModel.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 5),
                color: themeModel.shadowColor)
          ]),
      //  padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: goToProduct,
        child: Container(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: goToProduct,
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                  color: Colors.transparent,
                  child: Hero(
                    tag: cartItem.product!.reference,
                    child: FadeInImage(
                      width: width * 0.2,
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(cartItem.product!.image),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: goToProduct,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 20, bottom: 20, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Texts.headline3(
                              cartItem.product!.title, themeModel.textColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Texts.text(
                              cartItem.quantity.toString() +
                                  " " +
                                  cartItem.unit,
                              themeModel.secondTextColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Texts.text(
                                (Decimal.parse(((cartItem.unit == 'Piece')
                                                    ? cartItem
                                                        .product!.pricePerPiece
                                                    : (cartItem.unit == 'KG')
                                                        ? cartItem
                                                            .product!.pricePerKg
                                                        : cartItem.product!
                                                                .pricePerKg! *
                                                            0.001)
                                                .toString()) *
                                            Decimal.parse(
                                                cartItem.quantity.toString()))
                                        .toString() +
                                    "\$",
                                themeModel.priceColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    child: GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: themeModel.secondTextColor,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return EditCarItem.create(
                                    pricePerKg: cartItem.product!.pricePerKg,
                                    pricePerPiece:
                                        cartItem.product!.pricePerPiece,
                                    quantity: cartItem.quantity,
                                    initialUnitTitle: cartItem.unit,
                                    updateQuantity: updateQuantity,
                                    reference: cartItem.reference,
                                    updateUnit: updateUnit);
                              });
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, top: 20),
                    child: GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: themeModel.secondTextColor,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      color: themeModel.theme.backgroundColor),
                                  padding: EdgeInsets.all(20),
                                  child: Wrap(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Texts.headline2("Are you Sure?",
                                            themeModel.textColor),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Buttons.button(
                                                widget: Texts.headline3(
                                                    "Cancel",
                                                    themeModel.secondTextColor),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                color:
                                                    themeModel.secondTextColor,
                                                border: true,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Buttons.button(
                                                    widget: Texts.headline3(
                                                        "Delete", Colors.white),
                                                    onPressed: () async {
                                                      await delete();
                                                      Navigator.pop(context);
                                                    },
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget settings({
    required ThemeModel themeModel,
    required String title,
    required IconData iconData,
    required void Function() onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: themeModel.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.only(
        bottom: 10,
        left: 20,
        right: 20,
      ),
      //   padding: EdgeInsets.all(20),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        onTap: onTap,
        leading: Icon(
          iconData,
          color: themeModel.accentColor,
        ),
        title: Texts.text(title, themeModel.textColor),
        trailing: Icon(
          Icons.navigate_next,
          color: themeModel.textColor,
        ),
      ),
    );
  }

  static Widget address(
    BuildContext context, {
    required Address address,
  }) {
    final themeModel = Provider.of<ThemeModel>(context);
    final bloc = Provider.of<AddressesBloc>(context);

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: themeModel.secondBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 5),
                  color: themeModel.shadowColor)
            ]),
        child: Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Texts.headline3(address.name, themeModel.textColor),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child:
                        Texts.text(address.address, themeModel.secondTextColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Texts.text(
                        "${address.city == null ? "" : address.city! + ", "}${address.state}, ${address.country}, ${address.zipCode} ",
                        themeModel.secondTextColor),
                  ),
                  Row(
                    children: [
                      Texts.text(address.phone, themeModel.secondTextColor),
                      Spacer(),
                      Checkbox(
                        key: Key(address.id),
                        value: address.selected,
                        onChanged: (value) {
                          if (!address.selected) {
                            bloc.setSelectedAddress(address.id);
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: themeModel.secondTextColor,
                ),
                onPressed: () {
                  ///Show delete dialog when clicking
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              color: themeModel.theme.backgroundColor),
                          padding: EdgeInsets.all(20),
                          child: Wrap(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Texts.headline2("Are you Sure?",
                                    themeModel.secondTextColor),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Buttons.button(
                                        widget: Texts.headline3("Cancel",
                                            themeModel.secondTextColor),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: themeModel.secondTextColor,
                                        border: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Buttons.button(
                                            widget: Texts.headline3(
                                                "Delete", Colors.white),
                                            onPressed: () async {
                                              await bloc
                                                  .deleteAddress(address.id);
                                              Navigator.pop(context);
                                            },
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        AddAddress.create(context, address: address);
      },
    );
  }
}
