import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/helpers/project_configuration.dart';
import 'package:grocery/models/data_models/address.dart';
import 'package:grocery/models/data_models/cart_item.dart';
import 'package:grocery/models/state_models/checkout_model.dart';
import 'package:grocery/models/data_models/coupon.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/services/stripe_payment.dart';
import 'package:grocery/models/data_models/shipping_method.dart' as p;
import 'package:http/http.dart' as http;
import 'package:decimal/decimal.dart';
import 'package:grocery/widgets/dialogs.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class PaymentModel with ChangeNotifier {
  final Database database;
  final AuthBase auth;

  bool paymentViaDelivery = true;
  bool isLoading = false;

  PaymentModel({required this.database, required this.auth});

  void changePaymentMethod(value) {
    paymentViaDelivery = value;

    notifyListeners();
  }

  Future<void> submit(
    BuildContext context, {
    required Address address,
    required p.ShippingMethod shippingMethod,
    required List<CartItem> cartItems,
    required num order,
    Coupon? coupon,
  }) async {
    final checkoutModel = Provider.of<CheckoutModel>(context, listen: false);
    isLoading = true;
    notifyListeners();

    if (paymentViaDelivery) {
      await _submitOrder(context,
          address: address,
          shippingMethod: shippingMethod,
          cartItems: cartItems,
          order: order,
          paymentType: "Cash in delivery",
          coupon: coupon);
      isLoading = false;
      notifyListeners();
    } else {
      try {
        num total = checkoutModel.getDiscountedTotal();

        ///Payment process
        String paymentReference = await StripeService.payWithCard(
            ((Decimal.parse(total.toString())) * Decimal.parse('100'))
                .toString());

        await _submitOrder(context,
            address: address,
            shippingMethod: shippingMethod,
            cartItems: cartItems,
            order: order,
            paymentType: "Via credit card",
            paymentReference: paymentReference,
            coupon: coupon);
      } catch (e) {
        if (e is PlatformException) {
          ///Show error dialog if payment not successful
          if (e.message != 'cancelled') {
            showDialog(
                context: context,
                builder: (context) =>
                    Dialogs.error(context, message: e.message!));
          }
        }
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  ///Order submission on firebase
  Future _submitOrder(
    BuildContext context, {
    required Address address,
    required p.ShippingMethod shippingMethod,
    required List<CartItem> cartItems,
    required num order,
    required String paymentType,
    String? paymentReference,
    Coupon? coupon,
  }) async {
    DateTime dateTime = DateTime.now();
    String id = dateTime.day.toString() +
        dateTime.hour.toString() +
        dateTime.minute.toString() +
        dateTime.microsecond.toString();
    final checkoutModel = Provider.of<CheckoutModel>(context, listen: false);

    num total = checkoutModel.getDiscountedTotal();

    List<Map> cartItemsMap = cartItems.map((cartItem) {
      return {
        "id": cartItem.reference,
        "title": cartItem.product!.title,
        "quantity": cartItem.quantity.toString() + " " + cartItem.unit,
        "price": num.parse((Decimal.parse(((cartItem.unit == 'Piece')
                        ? cartItem.product!.pricePerPiece
                        : (cartItem.unit == 'KG')
                            ? cartItem.product!.pricePerKg
                            : cartItem.product!.pricePerKg! * 0.001)
                    .toString()) *
                Decimal.parse(cartItem.quantity.toString()))
            .toString()),
      };
    }).toList();

    Map<String, dynamic> data = {
      "date": dateTime.year.toString() +
          '-' +
          ((dateTime.month < 10)
              ? "0" + dateTime.month.toString()
              : dateTime.month.toString()) +
          '-' +
          ((dateTime.day < 10)
              ? "0" + dateTime.day.toString()
              : dateTime.day.toString()) +
          " " +
          ((dateTime.hour < 10)
              ? "0" + dateTime.hour.toString()
              : dateTime.hour.toString()) +
          ':' +
          ((dateTime.minute < 10)
              ? "0" + dateTime.minute.toString()
              : dateTime.minute.toString()),
      "products": cartItemsMap,
      "shipping_method": {
        "title": shippingMethod.title,
        "price": shippingMethod.price,
      },
      "payment_method": paymentType,
      "shipping_address": {
        "name": address.name,
        "address": address.address,
        "city": address.city,
        "state": address.state,
        "country": address.country,
        "zip_code": address.zipCode,
        "phone": address.phone,
      },
      "status": "Processing",
      "order": order,
      "total": total,
    };

    if (paymentReference != null) {
      data["payment_reference"] = paymentReference;
    }

    if (coupon != null) {
      data['coupon'] = {
        'code': coupon.code,
        'type': coupon.type,
        'expiry_date': coupon.expiryDate.toString().substring(0, 10),
        'value': coupon.value
      };
    }

    await database.setData(data, "users/${auth.uid}/orders/$id");

    await _sendNotification("Order nº$id is placed", id);

    Navigator.pop(context, true);
  }

  ///Send notification to admin
  Future<void> _sendNotification(String msg, String id) async {
    String? token = await _getToken();

    if (token != null) {
      final body = {
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": id,
          "status": "done",
          "body": msg,
          "title": "New order!",
        },
        "to": "$token"
      };

      try {
        await http.post(Uri.parse(ProjectConfiguration.notificationsApi),
            body: json.encode(body));
      } catch (e) {
        print(e);
      }
    }
  }

  ///get admin fcm token
  Future<String?> _getToken() async {
    try {
      final snapshot =
          await database.getFutureDataFromDocument("admin/notifications");
      Map data = snapshot.data() as Map;

      return data['token'];
    } catch (e) {
      return null;
    }
  }
}
