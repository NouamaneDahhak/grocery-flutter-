import 'package:delivery/blocs/deliveries_bloc.dart';
import 'package:delivery/models/data_models/order.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/cards.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Deliveries extends StatefulWidget {
  final DeliveriesBloc bloc;

  Deliveries._({required this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);

    return Provider<DeliveriesBloc>(
      create: (context) => DeliveriesBloc(auth: auth, database: database),
      child: Consumer<DeliveriesBloc>(
        builder: (context, bloc, _) {
          return Deliveries._(bloc: bloc);
        },
      ),
    );
  }

  @override
  _DeliveriesState createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.bloc.loadOrders(10);
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return RefreshIndicator(
        onRefresh: ()async{

          widget.bloc.refresh(10);
        },

        child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            if (_scrollController.position.extentAfter == 0) {
              widget.bloc.loadOrders(10);
            }
          }
          return false;
        },
        child: StreamBuilder<List<Order>>(
            stream: widget.bloc.ordersStream,
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
                        child: Cards.order(context,
                            order: orders[position],
                            removeOrderLocally: widget.bloc.removeOrderLocally),
                      );
                    },
                    itemCount: orders.length,
                  );
                }
              } else if (snapshot.hasError) {
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
            })));
  }
}
