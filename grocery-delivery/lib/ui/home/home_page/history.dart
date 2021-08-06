import 'package:delivery/blocs/history_bloc.dart';
import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/cards.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class History extends StatefulWidget {
  final HistoryBloc bloc;

  History._({required this.bloc});

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<HistoryBloc>(
      create: (context) => HistoryBloc(database: database, auth: auth),
      child: Consumer<HistoryBloc>(
        builder: (context, bloc, _) {
          return History._(bloc: bloc);
        },
      ),
    );
  }

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.bloc.loadHistory(5);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeModel = Provider.of<ThemeModel>(context, listen: false);

    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          if (_scrollController.position.extentAfter == 0) {
            widget.bloc.loadHistory(5);
          }
        }
        return false;
      },
      child: StreamBuilder<List<HistoryItem>>(
        stream: widget.bloc.historyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              ///If no orders
              return Center(
                child: FadeIn(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/nothing_found.svg',
                          width: width * 0.5,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Texts.headline3(
                              'No History found!', themeModel.accentColor,
                              alignment: TextAlign.center),
                        )
                      ]),
                ),
              );
            } else {
              ///If there are history
              List<HistoryItem> histories = snapshot.data!;

              return ListView.builder(
                padding: EdgeInsets.only(bottom: 80),
                itemCount: histories.length,
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  return FadeIn(
                    child: Cards.history(context, history: histories[position]),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            ///If there is an error
            return FadeIn(
              child: Center(
                child: SvgPicture.asset(
                  'images/error.svg',
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            ///If loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
