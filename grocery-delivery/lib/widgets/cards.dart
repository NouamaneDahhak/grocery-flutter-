import 'package:delivery/blocs/deliveries_bloc.dart';
import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/models/data_models/order.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/ui/home/home_page/delivery_details/delivery_details.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:delivery/widgets/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///All cards used in the app
class Cards {
  static Widget order(
    BuildContext context, {
    required Order order,
    required void Function(Order) removeOrderLocally,
  }) {
    final themeModel = Provider.of<ThemeModel>(context);
    final bloc = Provider.of<DeliveriesBloc>(context);

    return ListTile(
      title: Texts.headline3("Order N:" + order.id, themeModel.textColor),
      subtitle: Texts.text(order.date, themeModel.secondTextColor),
      onTap: () {
        DeliveryDetails.create(context, order.path).then((value) async {
          if (value != null) {
            await bloc.changeStatus(value, order.path);
            removeOrderLocally(order);
          }
        });
      },
    );
  }

  static Widget history(BuildContext context, {required HistoryItem history}) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: BoxDecoration(
          color: themeModel.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 30,
                offset: Offset(0, 5),
                color: themeModel.shadowColor)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Order number
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Texts.headline3(
                "Order #" + history.order, themeModel.textColor),
          ),

          ///History date
          Row(
            children: [
              Texts.headline3("Date: ", themeModel.textColor),
              Spacer(),
              Texts.text("${history.date}", themeModel.secondTextColor),
            ],
          ),

          ///Order status
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Texts.headline3("Status: ", themeModel.textColor),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (history.status == 'Delivered')
                          ? Colors.green
                          : Colors.red),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(
                    (history.status == 'Delivered') ? Icons.done : Icons.clear,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                Texts.headline3(
                    history.status,
                    (history.status == 'Delivered')
                        ? Colors.green
                        : Colors.red),
              ],
            ),
          ),

          //History comment/reason
          Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: Texts.headline3(
                history.status == "Delivered" ? "Comment:" : "Reason:",
                themeModel.textColor),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Texts.text(history.comment, themeModel.secondTextColor),
          ),

          //History Image
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Texts.headline3("Image:", themeModel.textColor),
          ),

          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(history.image),
                        ),
                      );
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  width: isPortrait ? width * 0.5 : height * 0.5,
                  image: NetworkImage(history.image),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
