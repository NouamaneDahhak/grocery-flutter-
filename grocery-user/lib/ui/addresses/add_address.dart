import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models/state_models/add_address_model.dart';
import 'package:grocery/models/data_models/address.dart';
import 'package:grocery/models/state_models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/widgets/buttons.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/text_fields.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  final AddAddressModel model;
  final Address? address;

  AddAddress({required this.model, this.address});

  static void create(BuildContext context, {Address? address}) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider<AddAddressModel>(
            create: (context) => AddAddressModel(
              uid: auth.uid,
              database: database,
            ),
            child: Consumer<AddAddressModel>(
              builder: (context, model, _) {
                return AddAddress(
                  model: model,
                  address: address,
                );
              },
            ),
          ),
        ));
  }

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> with TickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode zipCodeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      nameController = TextEditingController(text: widget.address!.name);
      addressController = TextEditingController(text: widget.address!.address);
      cityController = TextEditingController(text: widget.address!.city ?? "");
      stateController = TextEditingController(text: widget.address!.state);

      List<Map<String, dynamic>> countryMap = codes
          .where((element) => element['name'] == widget.address!.country)
          .toList();
      if (countryMap.isNotEmpty) {
        widget.model.country = CountryCode.fromJson(countryMap.single);
      }

      phoneController = TextEditingController(
          text: widget.address!.phone
              .replaceFirst(widget.model.country.dialCode!, ""));
      zipCodeController = TextEditingController(text: widget.address!.zipCode);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    phoneController.dispose();
    zipCodeController.dispose();

    nameFocus.dispose();
    addressFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    phoneFocus.dispose();
    zipCodeFocus.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3(
            (widget.address != null) ? "Edit address" : "Add address",
            themeModel.textColor),
        centerTitle: true,
        backgroundColor: themeModel.secondBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
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
          ///Full name field
          TextFields.addressTextField(
              themeModel: themeModel,
              controller: nameController,
              focusNode: nameFocus,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "Full name",
              error: !widget.model.validName,
              enabled: !widget.model.isLoading,
              onSubmitted: (value) {
                _fieldFocusChange(context, nameFocus, addressFocus);
              }),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validName)
                  ? FadeIn(
                      child: Texts.helperText(
                          "Please enter a valid name", Colors.red),
                    )
                  : SizedBox(),
            ),
          ),

          ///Address field
          TextFields.addressTextField(
              themeModel: themeModel,
              controller: addressController,
              focusNode: addressFocus,
              error: !widget.model.validAddress,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "Address",
              onSubmitted: (value) {
                _fieldFocusChange(context, addressFocus, cityFocus);
              }),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validAddress)
                  ? FadeIn(
                      child: Texts.helperText(
                          "Please enter a valid address", Colors.red),
                    )
                  : SizedBox(),
            ),
          ),

          ///City field
          TextFields.addressTextField(
              themeModel: themeModel,
              controller: cityController,
              focusNode: cityFocus,
              error: !widget.model.validCity,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "City",
              onSubmitted: (value) {
                _fieldFocusChange(context, cityFocus, stateFocus);
              }),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validCity)
                  ? FadeIn(
                      child: Texts.helperText(
                          "Please enter a valid city", Colors.red),
                    )
                  : SizedBox(),
            ),
          ),

          ///State-Province field
          TextFields.addressTextField(
              themeModel: themeModel,
              controller: stateController,
              focusNode: stateFocus,
              error: !widget.model.validState,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: "State/Province",
              onSubmitted: (value) {
                _fieldFocusChange(context, stateFocus, zipCodeFocus);
              }),

          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validState)
                  ? FadeIn(
                      child: Texts.helperText(
                          "Please enter a valid state", Colors.red),
                    )
                  : SizedBox(),
            ),
          ),

          ///Zip code field
          TextFields.addressTextField(
              themeModel: themeModel,
              controller: zipCodeController,
              focusNode: zipCodeFocus,
              error: !widget.model.validZip,
              enabled: !widget.model.isLoading,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              labelText: "Zip code",
              onSubmitted: (value) {
                _fieldFocusChange(context, zipCodeFocus, phoneFocus);
              }),

          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validZip)
                  ? FadeIn(
                      child: Texts.helperText(
                          "Please enter a valid zip code", Colors.red),
                    )
                  : SizedBox(),
            ),
          ),

          ///Country field
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: themeModel.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            padding: EdgeInsets.all(12),
            child: CountryCodePicker(
                initialSelection: 'US',
                padding: EdgeInsets.all(0),
                dialogBackgroundColor: themeModel.backgroundColor,
                barrierColor: themeModel.shadowColor,
                showOnlyCountryWhenClosed: true,
                onChanged: widget.model.changeCountry),
          ),

          ///Phone field
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                    color: (!widget.model.validPhone)
                        ? Colors.red
                        : themeModel.secondBackgroundColor,
                    width: 2)),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Texts.text(
                      widget.model.country.dialCode!, themeModel.textColor),
                ),
                Expanded(
                  child: TextField(
                    enabled: !widget.model.isLoading,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: phoneController,
                    focusNode: phoneFocus,
                    onSubmitted: (value) {
                      ///Submit function
                      widget.model.addAddress(
                        context,
                        name: nameController.text,
                        address: addressController.text,
                        city: cityController.text,
                        state: stateController.text,
                        zipCode: zipCodeController.text,
                        phone: phoneController.text,
                        editedId: (widget.address != null)
                            ? widget.address!.id
                            : null,
                      );
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Phone",
                        contentPadding: EdgeInsets.only(
                          left: 20,
                          // right: 20
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validPhone)
                  ? FadeIn(
                      child: Texts.helperText(
                          "Please enter a valid phone", Colors.red),
                    )
                  : SizedBox(),
            ),
          ),

          (widget.model.isLoading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Buttons.button(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Texts.headline3(
                            (widget.address != null) ? 'Update' : 'Save',
                            Colors.white),
                      )
                    ],
                  ),
                  onPressed: () {
                    ///Submit function

                    widget.model.addAddress(
                      context,
                      name: nameController.text,
                      address: addressController.text,
                      city: cityController.text,
                      state: stateController.text,
                      zipCode: zipCodeController.text,
                      phone: phoneController.text,
                      editedId:
                          (widget.address != null) ? widget.address!.id : null,
                    );
                  },
                  color: themeModel.accentColor),
        ],
      ),
    );
  }
}
