import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/models/state_models/add_delivery_boy_model.dart';
import 'package:grocery_admin/models/data_models/delivery_boy.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/text_fields.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:grocery_admin/widgets/transparent_image.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddDeliveryBoy extends StatefulWidget {
  final AddDeliveryBoyModel model;
  final DeliveryBoy? deliveryBoy;

  static create(BuildContext context, {DeliveryBoy? deliveryBoy}) {
    final database = Provider.of<Database>(context, listen: false);

    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return ChangeNotifierProvider<AddDeliveryBoyModel>(
        create: (context) => AddDeliveryBoyModel(database: database),
        child: Consumer<AddDeliveryBoyModel>(
          builder: (context, model, _) {
            return AddDeliveryBoy._(
              model: model,
              deliveryBoy: deliveryBoy,
            );
          },
        ),
      );
    }));
  }

  AddDeliveryBoy._({required this.model, this.deliveryBoy});

  @override
  _AddDeliveryBoyState createState() => _AddDeliveryBoyState();
}

class _AddDeliveryBoyState extends State<AddDeliveryBoy>
    with TickerProviderStateMixin {
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  FocusNode fullNameFocus = new FocusNode();
  FocusNode emailFocus = new FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.deliveryBoy != null) {
      fullNameController =
          new TextEditingController(text: widget.deliveryBoy!.fullName);
      emailController =
          new TextEditingController(text: widget.deliveryBoy!.email);

      if (widget.deliveryBoy!.image != null) {
        widget.model.image = widget.deliveryBoy!.image!;
        widget.model.networkImage = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    fullNameFocus.dispose();
    emailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3('Add Delivery Boy', themeModel.textColor),
        backgroundColor: themeModel.secondBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: themeModel.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFields.defaultTextField(
              controller: fullNameController,
              focusNode: fullNameFocus,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              labelText: 'Full name',
              onSubmitted: (value) {},
              error: !widget.model.validFullName,
              isLoading: widget.model.isLoading,
              themeModel: themeModel),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validFullName)
                ? FadeIn(
                    child: Texts.helperText(
                        'Please enter a valid name', Colors.red),
                  )
                : SizedBox(),
          ),
          TextFields.defaultTextField(
              margin: EdgeInsets.only(top: 10),
              controller: emailController,
              focusNode: emailFocus,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
              labelText: 'Email',
              onSubmitted: (value) {},
              error: !widget.model.validEmail,
              isLoading: widget.model.isLoading,
              enabled: widget.deliveryBoy == null,
              themeModel: themeModel),
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
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  widget.model.changeImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: (widget.model.networkImage)
                      ? FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(widget.model.image!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: (widget.model.image == null)
                              ? AssetImage('images/profile.png')
                              : FileImage(File(widget.model.image!)) as ImageProvider,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          (widget.model.isLoading)
              ? Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Buttons.button(
                  widget: Texts.headline3("Add Boy", Colors.white),
                  onPressed: () {
                    widget.model.submit(
                      context,
                      fullNameController.text,
                      emailController.text,
                      deliveryBoy: widget.deliveryBoy!,
                    );


                  },
                  color: themeModel.accentColor),
        ],
      ),
    );
  }
}
