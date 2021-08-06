import 'package:flutter/material.dart';
import 'package:grocery_admin/helpers/project_configuration.dart';
import 'package:grocery_admin/models/state_models/sign_in_model.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/text_fields.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:grocery_admin/widgets/transparent_image.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final SignInModel model;

  SignIn({required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return ChangeNotifierProvider<SignInModel>(
      create: (BuildContext context) =>
          SignInModel(auth: auth, database: database),
      child: Consumer<SignInModel>(
        builder: (context, model, _) {
          return SignIn(
            model: model,
          );
        },
      ),
    );
  }

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      body: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: FadeInImage(
                image: AssetImage(ProjectConfiguration.logo),
                placeholder:  MemoryImage(kTransparentImage),
                width: 100,
                height: 100,
              ),
            ),
            TextFields.emailTextField(
                themeModel: themeModel,
                controller: emailController,
                isLoading: widget.model.isLoading,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
                labelText: "Email",
                iconData: Icons.email,
                onSubmitted: () {
                  _fieldFocusChange(context, emailFocus, passwordFocus);
                },
                error: !widget.model.validEmail),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validEmail)
                  ? FadeIn(
                      child: Texts.helperText(
                          'Please enter a valid email', Colors.red),
                    )
                  : SizedBox(),
            ),
            TextFields.emailTextField(
                themeModel: themeModel,
                controller: passwordController,
                isLoading: widget.model.isLoading,
                focusNode: passwordFocus,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                obscureText: true,
                labelText: "Password",
                iconData: Icons.lock_outline,
                onSubmitted: () {
                  widget.model.signInWithEmail(
                      context, emailController.text, passwordController.text);
                },
                error: !widget.model.validPassword),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validPassword)
                  ? FadeIn(
                      child: Texts.helperText(
                          'Please enter a valid password : don\'t forget numbers, special characters(@, # ...), capital letters',
                          Colors.red),
                    )
                  : SizedBox(),
            ),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: widget.model.isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Buttons.button(
                      color: themeModel.accentColor,
                      widget: Texts.headline3("SIGN IN", Colors.white),
                onPressed: () {
                        //Sign In function
                        widget.model.signInWithEmail(context,
                            emailController.text, passwordController.text);
                      },
                    ),
            ),
          ],
        ),
      )),
    );
  }
}
