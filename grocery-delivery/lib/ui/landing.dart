import 'package:delivery/blocs/landing_bloc.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/transitions/FadeRoute.dart';
import 'package:delivery/ui/home/home.dart';
import 'package:delivery/ui/sign_in.dart';
import 'package:delivery/widgets/dialogs.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  final LandingBloc bloc;

  Landing._({required this.bloc});

  static create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    Navigator.pushReplacement(
        context,
        FadeRoute(
            page: Provider<LandingBloc>(
          create: (context) => LandingBloc(auth: auth, database: database),
          child: Consumer<LandingBloc>(builder: (context, bloc, _) {
            return Landing._(bloc: bloc);
          }),
        )));
  }

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late Stream<User?> authStream;

  @override
  void initState() {
    super.initState();
    authStream = widget.bloc.getSignedUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: authStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FadeIn(
              child: Home.create(context),
            );
          } else {
            ///If there is an error show error Dialog
            if (widget.bloc.isError) {
              print('Error');

              SchedulerBinding.instance!.addPostFrameCallback((_) {
                showDialog(
                    context: context,
                    builder: (context) => Dialogs.error(context,
                        message: "You are not a delivery boy!"));
              });
            }

            return FadeIn(
              child: FadeIn(
                child: SignIn.create(context),
              ),
            );
          }
        });
  }
}
