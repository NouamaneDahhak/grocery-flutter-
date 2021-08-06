import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocery_admin/blocs/delivery_boys_bloc.dart';
import 'package:grocery_admin/models/data_models/category.dart';
import 'package:grocery_admin/models/data_models/coupon.dart';
import 'package:grocery_admin/models/data_models/delivery_boy.dart';
import 'package:grocery_admin/models/data_models/order.dart';
import 'package:grocery_admin/models/data_models/product.dart';
import 'package:grocery_admin/models/data_models/shipping_method.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/ui/home/categories/add_category.dart';
import 'package:grocery_admin/ui/home/coupons/add_coupon.dart';
import 'package:grocery_admin/ui/home/delivery_boys/add_delivery_boy.dart';
import 'package:grocery_admin/ui/home/orders/order_details/order_details.dart';
import 'package:grocery_admin/ui/home/products/add_product.dart';
import 'package:grocery_admin/ui/home/shipping/add_shipping.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:grocery_admin/widgets/transparent_image.dart';
import 'package:provider/provider.dart';

///All cards used in the app
class Cards {
  static Widget shipping(BuildContext context,
      {required ShippingMethod shippingMethod,
      required void Function() function}) {
    final themeModel = Provider.of<ThemeModel>(context);

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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Texts.headline3(
                        shippingMethod.title, themeModel.textColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      child: Texts.descriptionText(
                          shippingMethod.duration! +
                              " (${shippingMethod.price}\$)",
                          themeModel.secondTextColor),
                      onTap: () {},
                    ),
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
                                child: Texts.headline2(
                                    "Are you Sure?", themeModel.textColor),
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
                                            onPressed: function,
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
        AddShipping.create(context, shippingMethod: shippingMethod);
      },
    );
  }

  static Widget coupon(BuildContext context,
      {required Coupon coupon, required void Function() function}) {
    final themeModel = Provider.of<ThemeModel>(context);

    DateTime dateTime =
        DateTime.parse(DateTime.now().toString().substring(0, 10));

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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Texts.headline3(coupon.code, themeModel.textColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Texts.descriptionText(
                            "Value: ", themeModel.secondTextColor),
                        Texts.descriptionText(
                            coupon.value.toString() +
                                ((coupon.type == "percentage") ? "%" : "\$"),
                            themeModel.priceColor),
                      ],
                    ),
                  ),
                  (dateTime.isAtSameMomentAs(coupon.expiryDate) ||
                          dateTime.isBefore(coupon.expiryDate))
                      ? Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Texts.descriptionText(
                                  "Expire on ", themeModel.secondTextColor),
                              Texts.descriptionText(
                                  coupon.expiryDate.toString().substring(0, 10),
                                  themeModel.priceColor),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Texts.descriptionText("Expired", Colors.red),
                        )
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
                                child: Texts.headline2(
                                    "Are you Sure?", themeModel.textColor),
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
                                            onPressed: function,
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
        AddCoupon.create(context, coupon: coupon);
      },
    );
  }

  static Widget product(
    BuildContext context, {
    required Product product,
    required void Function() delete,
    required void Function(Product) edit,
  }) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;

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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInImage(
                    height: (width * 0.5) / (width ~/ 180),
                    image: NetworkImage(product.image),
                    placeholder: MemoryImage(kTransparentImage),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: themeModel.secondTextColor,
                ),
                onPressed: () {
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
                                child: Texts.headline2(
                                    "Are you Sure?", themeModel.textColor),
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
                                            onPressed: delete,
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
        AddProduct.create(context, product: product).then((value) {
          if (value != null) {
            edit(value);
          }
        });
      },
    );
  }

  static Widget settings(
    BuildContext context, {
    required String title,
    required void Function() onPressed,
    required Widget widget,
    required Color? color,
  }) {
    final themeModel = Provider.of<ThemeModel>(context);

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget,
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Texts.descriptiveItems(
                    title, color ?? themeModel.textColor,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    alignment: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      onTap: onPressed,
    );
  }

  static Widget category(BuildContext context,
      {required Category category, required void Function() function}) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;

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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInImage(
                    height: (width * 0.5) / (width ~/ 180),
                    image: NetworkImage(category.image),
                    placeholder: MemoryImage(kTransparentImage),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Texts.text(category.title, themeModel.textColor,
                        textOverflow: TextOverflow.ellipsis, maxLines: 1),
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
                                child: Texts.headline2(
                                    "Are you Sure?", themeModel.textColor),
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
                                            onPressed: function,
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
        AddCategory.create(context, category: category);
      },
    );
  }

  static Widget order(
    BuildContext context, {
    required Order order,
    required void Function(Order) refresh,
  }) {
    final themeModel = Provider.of<ThemeModel>(context);
    return ListTile(
      title: Texts.headline3("Order N:" + order.id, themeModel.textColor),
      subtitle: Texts.text(order.date, themeModel.secondTextColor),
      onTap: () {
        OrderDetails.create(context, order.path, order.status).then((value) {
          if (value != null) {
            refresh(order);
          }
        });
      },
    );
  }

  static Widget deliveryBoy(BuildContext context,
      {required DeliveryBoy deliveryBoy, bool selectAction = false}) {
    final themeModel = Provider.of<ThemeModel>(context);
    final bloc = Provider.of<DeliveryBoysBloc>(context);

    return Slidable(
      child: ListTile(
        title: Texts.headline3(deliveryBoy.fullName, themeModel.textColor),
        subtitle: Texts.text(
            "Email: " + deliveryBoy.email, themeModel.secondTextColor),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: (deliveryBoy.image != null)
                ? NetworkImage(deliveryBoy.image!)
                : AssetImage('images/profile.png') as ImageProvider,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          if (selectAction) {
            Navigator.pop(context, deliveryBoy);
          } else {
            AddDeliveryBoy.create(context, deliveryBoy: deliveryBoy);
          }
        },
      ),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'Edit',
          color: themeModel.accentColor,
          icon: Icons.edit,
          foregroundColor: themeModel.textColor,
          onTap: () {
            AddDeliveryBoy.create(context, deliveryBoy: deliveryBoy);
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            await bloc.removeDelivery(deliveryBoy.email);
          },
        ),
      ],
    );
  }
}
