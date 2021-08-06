
class ShippingMethod {
  final String? id;
  final String title;
  final num price;
  final String? duration;
  bool selected;

  ShippingMethod(
      {this.id,required this.title, required this.price, this.duration,this.selected=false});

  factory ShippingMethod.fromMap(Map<String, dynamic> data,String id) {
    return ShippingMethod(
      id: id,
      title: data['title'],
      price: data['price'],
      duration: data['duration'],
    );
  }
}
