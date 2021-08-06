import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grocery_admin/blocs/order_details_bloc.dart';
import 'package:grocery_admin/models/data_models/delivery_boy.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/ui/home/delivery_boys/delivery_boys.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:grocery_admin/widgets/transparent_image.dart';
import 'package:provider/provider.dart';

class DeliveryBoyDetails extends StatefulWidget {
  final StreamController<bool> controller;

  final DeliveryBoy? deliveryBoy;
  final String status;

  DeliveryBoyDetails(
      {required this.controller,
       this.deliveryBoy,
      required this.status});

  @override
  _DeliveryBoyDetailsState createState() => _DeliveryBoyDetailsState();
}

class _DeliveryBoyDetailsState extends State<DeliveryBoyDetails>
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
                  Icons.delivery_dining,
                  color: themeModel.textColor,
                ),
                title: Texts.headline3("Delivery Boy", themeModel.textColor),
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
                      padding: EdgeInsets.only(bottom: 10),

                      child: (widget.deliveryBoy != null)
                      ///Delivery boy details
                          ? ListTile(
                              title: Texts.headline3(
                                  widget.deliveryBoy!.fullName,
                                  themeModel.textColor),
                              subtitle: Texts.text(
                                  "Email: " + widget.deliveryBoy!.email,
                                  themeModel.secondTextColor),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: FadeInImage(
                                  placeholder: MemoryImage(kTransparentImage),
                                  image: (widget.deliveryBoy!.image != null)
                                      ? NetworkImage(widget.deliveryBoy!.image!)
                                      : AssetImage('images/profile.png') as ImageProvider,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: themeModel.textColor,
                                ),
                                onPressed: () async {
                                  final orderDetailsBloc =
                                      Provider.of<OrderDetailsBloc>(context,
                                          listen: false);

                                  await orderDetailsBloc.removeDeliveryBoy();
                                },
                              ),
                            )
                      ///If order is Delivered or Declined can't add a delivery boy
                          : (widget.status == 'Delivered' ||
                                  widget.status == 'Declined')
                              ? ListTile(
                                  title: Texts.text(
                                      'Order is ${widget.status}, you can\'t add a delivery boy',
                                      themeModel.textColor),
                                )
                              : ListTile(
                                  onTap: () {
                                    DeliveryBoys.create(context,
                                            selectAction: true)
                                        .then((DeliveryBoy? value) async {
                                      if (value != null) {
                                        final orderDetailsBloc =
                                            Provider.of<OrderDetailsBloc>(
                                                context,
                                                listen: false);

                                        await orderDetailsBloc
                                            .setDeliveryBoy(value);
                                      }
                                    });
                                  },
                                  leading: Icon(
                                    Icons.add,
                                    color: themeModel.textColor,
                                  ),
                                  title: Texts.text(
                                      'Add delivery boy', themeModel.textColor),
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
