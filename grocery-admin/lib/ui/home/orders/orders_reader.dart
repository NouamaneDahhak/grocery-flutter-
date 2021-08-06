import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_admin/blocs/orders_reader_bloc.dart';
import 'package:grocery_admin/models/data_models/order.dart';
import 'package:grocery_admin/models/state_models/orders_model.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/widgets/cards.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrdersReader extends  StatelessWidget {
  final String? status;

  final OrdersReaderBloc bloc;

  static Widget create({String? status}) {

    return Consumer<OrdersReaderBloc>(
      builder: (context, bloc, _) {
        return OrdersReader(bloc: bloc, status: status);
      },
    );
  }

  OrdersReader({required this.bloc, this.status});

  ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final ordersModel = Provider.of<OrdersModel>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return RefreshIndicator(
        onRefresh: ()async{
         await bloc.refresh(10, status ?? 'Processing',ordersModel.date);
        },

        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (_scrollController.position.extentAfter == 0) {
                bloc.loadOrders(status ?? 'Processing',10,ordersModel.date);
              }
            }
            return false;
          },
          child: StreamBuilder<List<Order>>(
              stream: bloc.ordersStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Order> orders = snapshot.data!;

                  if (snapshot.data!.length == 0) {
                    return FadeIn(
                      duration: Duration(milliseconds: 300),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/nothing_found.svg',
                              width: isPortrait ? width * 0.5 : height * 0.5,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Texts.headline3(
                                  'Nothing found!', themeModel.accentColor,
                                  alignment: TextAlign.center),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemBuilder: (context, position) {
                        return FadeIn(
                          duration: Duration(milliseconds: 300),
                          child: Cards.order(
                            context,
                            order: orders[position],
                            refresh: bloc.removeOrderLocally,
                          ),
                        );
                      },
                      itemCount: orders.length,
                    );
                  }
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  print(snapshot.stackTrace);
                  return Center(
                    child: SvgPicture.asset(
                      'images/error.svg',
                      width: width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
