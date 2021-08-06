import 'package:delivery/models/data_models/address.dart';
import 'package:delivery/models/data_models/coupon.dart';
import 'package:delivery/models/data_models/order_product_items.dart';
import 'package:delivery/models/data_models/shipping_method.dart';

class Order {
  final String id;
  final List<OrdersProductItem> products;
  final ShippingMethod shippingMethod;
  final String status;
  final String date;
  final String path;
  final Address address;
  final String paymentMethod;
  final num total;
  final String? adminComment;
  final Coupon? coupon;

  factory Order.fromMap(Map data, String id, String path) {
    return Order(
      id: id,
      total: num.parse(data['total'].toString()),
      paymentMethod: data["payment_method"] ?? "Cash in Delivery",
      shippingMethod: ShippingMethod(
        title: data['shipping_method']['title'],
        price: num.parse(data['shipping_method']['price'].toString()),
      ),
      date: data['date'],
      products: OrdersProductItem.fromMap(data['products']),
      address: Address.fromMap(data['shipping_address']),
      status: data['status'] ?? "Processing",
      adminComment: data['admin_comment'],
      coupon:
          (data.containsKey('coupon')) ? Coupon.fromMap(data['coupon']) : null,
      path: path,
    );
  }

  Order(
      {required this.id,
      required this.date,
      required this.products,
      required this.shippingMethod,
      required this.paymentMethod,
      required this.status,
      required this.path,
      required this.address,
      required this.total,
      this.coupon,
      this.adminComment});
}
