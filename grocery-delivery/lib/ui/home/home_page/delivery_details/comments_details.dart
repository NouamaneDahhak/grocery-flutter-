import 'dart:async';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CommentsDetails extends StatefulWidget {
  final StreamController<bool> controller;
  String? adminComment;

  CommentsDetails({
    required this.controller,
    this.adminComment,
  });

  @override
  _CommentsDetailsState createState() => _CommentsDetailsState();
}

class _CommentsDetailsState extends State<CommentsDetails>
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
                  Icons.comment,
                  color: themeModel.textColor,
                ),
                title: Texts.headline3("Comments", themeModel.textColor),
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
                      padding: EdgeInsets.only(top: 5, bottom: 20),
                      child: FadeIn(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Admin comment
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 5, left: 20, right: 20),
                              child: Texts.subheads(
                                  'Admin Comment:', themeModel.textColor),
                            ),
                            (widget.adminComment != null)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Texts.text(widget.adminComment!,
                                        themeModel.secondTextColor),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Texts.text(
                                        'No comment provided by the admin',
                                        themeModel.secondTextColor),
                                  ),
                          ],
                        ),
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
