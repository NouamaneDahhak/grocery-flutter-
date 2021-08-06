import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/models/state_models/add_product_model.dart';
import 'package:grocery_admin/models/data_models/category.dart';
import 'package:grocery_admin/models/data_models/product.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/ui/home/categories/add_category.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/text_fields.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:grocery_admin/widgets/transparent_image.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  final AddProductModel model;

  final Product? product;

  AddProduct({required this.model, this.product});

  static Future<Product?> create(BuildContext context, {Product? product}) {
    final database = Provider.of<Database>(context, listen: false);

    return Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider<AddProductModel>(
                  create: (context) => AddProductModel(database: database),
                  child: Consumer<AddProductModel>(
                    builder: (context, model, _) {
                      return AddProduct(
                        model: model,
                        product: product,
                      );
                    },
                  ),
                )));
  }

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with TickerProviderStateMixin {
  TextEditingController titleController = TextEditingController();
  TextEditingController pricePerPieceController = TextEditingController();
  TextEditingController pricePerKgController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController storageController = TextEditingController();

  FocusNode titleFocus = FocusNode();
  FocusNode pricePerPieceFocus = FocusNode();
  FocusNode pricePerKgFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode originFocus = FocusNode();
  FocusNode storageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      titleController = TextEditingController(text: widget.product!.title);
      widget.model.category = widget.product!.category;
      pricePerPieceController =
          TextEditingController(text: widget.product!.pricePerPiece.toString());
      pricePerKgController = TextEditingController(
          text: (widget.product!.pricePerKg == null)
              ? ""
              : widget.product!.pricePerKg.toString());
      descriptionController =
          TextEditingController(text: widget.product!.description);
      originController = TextEditingController(text: widget.product!.origin);
      storageController = TextEditingController(text: widget.product!.storage);

      widget.model.networkImage = true;
      widget.model.image = widget.product!.image;

      if (widget.product!.pricePerKg != null) {
        widget.model.pricePerKgEnabled = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3(
            ((widget.product == null) ? 'Add' : 'Edit') + ' Product',
            themeModel.textColor),
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
              enabled: !widget.model.isLoading,
              themeModel: themeModel,
              controller: titleController,
              focusNode: titleFocus,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              labelText: 'Title',
              onSubmitted: (value) {},
              onChanged: (value) {
                if (titleController.text[0] !=
                    titleController.text[0].toUpperCase()) {
                  titleController.text = titleController.text.replaceFirst(
                      titleController.text[0],
                      titleController.text[0].toUpperCase());
                  titleController.selection = TextSelection.fromPosition(
                      TextPosition(offset: titleController.text.length));

                  widget.model.updateWidget();
                }
              },
              isLoading: widget.model.isLoading,
              error: !widget.model.validTitle),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validTitle)
                ? FadeIn(
                    child: Texts.helperText(
                        'Please enter a valid title', Colors.red),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width / 2 - 20,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: !widget.model.isLoading
                              ? themeModel.secondBackgroundColor
                              : themeModel.secondBackgroundColor
                                  .withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                              width: 2,
                              color: !widget.model.validCategory
                                  ? Colors.red
                                  : Colors.transparent),
                        ),
                        child: StreamBuilder<List<Category>>(
                          stream: widget.model.getCategories(),
                          builder: (context, snapshot) {
                            List<Category> categories = [];
                            print(snapshot.data);
                            if (snapshot.hasData) {
                              categories = snapshot.data!;
                            }

                            return DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: themeModel.secondBackgroundColor,
                              underline: SizedBox(),
                              hint: Texts.text(
                                  widget.model.category ?? "Category",
                                  themeModel.textColor),
                              onChanged: (value) {
                                widget.model.changeCategory(value);
                              },
                              items: List.generate(categories.length + 1,
                                  (position) {
                                return (position == 0)
                                    ? DropdownMenuItem(
                                        value: "Add category",
                                        child: GestureDetector(
                                          onTap: () {
                                            AddCategory.create(context)
                                                .then((value) {
                                              if (value == true) {
                                                Navigator.pop(context);

                                                widget.model.initCategory();
                                              }
                                            });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 18,
                                                    color: themeModel.textColor,
                                                  ),
                                                ),
                                                Texts.text("Add category",
                                                    themeModel.textColor),
                                              ],
                                            ),
                                          ),
                                        ))
                                    : DropdownMenuItem(
                                        value: categories[position - 1].title,
                                        child: Row(
                                          children: [
                                            Texts.text(
                                                categories[position - 1].title,
                                                themeModel.textColor),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                AddCategory.create(context,
                                                        category: categories[
                                                            position - 1])
                                                    .then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(context);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: themeModel.textColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            15),
                                                                  ),
                                                                  color: themeModel
                                                                      .theme
                                                                      .backgroundColor),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Wrap(
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Texts.headline2(
                                                                    "Are you Sure?",
                                                                    themeModel
                                                                        .textColor),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Buttons
                                                                          .button(
                                                                        widget: Texts.headline3(
                                                                            "Cancel",
                                                                            themeModel.secondTextColor),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: themeModel
                                                                            .secondTextColor,
                                                                        border:
                                                                            true,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 20),
                                                                        child: Buttons.button(
                                                                            widget: Texts.headline3("Delete", Colors.white),
                                                                            onPressed: () async {
                                                                              if (widget.model.category == categories[position - 1].title) {
                                                                                widget.model.category = null;
                                                                              }

                                                                              await widget.model.deleteCategory(categories[position - 1].title).then((value) {
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              });
                                                                            },
                                                                            color: Colors.red),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: themeModel.textColor,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ));
                              }),
                            );
                          },
                        ),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validCategory)
                            ? FadeIn(
                                child: Texts.helperText(
                                    'Please choose a category', Colors.red),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width / 2 - 20,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Container(
                        child: TextFields.defaultTextField(
                            themeModel: themeModel,
                            enabled: !widget.model.isLoading,
                            controller: pricePerPieceController,
                            focusNode: pricePerPieceFocus,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            labelText: 'Price per Piece',
                            onSubmitted: (value) {},
                            isLoading: widget.model.isLoading,
                            error: !widget.model.validPricePerPiece),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: (!widget.model.validPricePerPiece)
                            ? FadeIn(
                                child: Texts.helperText(
                                    'Please enter a valid price per piece',
                                    Colors.red),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: widget.model.pricePerKgEnabled,
                        onChanged: !widget.model.isLoading
                            ? (value) {
                                pricePerKgController.clear();
                                widget.model.updatePricePerKgState();
                              }
                            : (v) {}),
                    Container(
                      width: width / 2 - 20,
                      padding: EdgeInsets.only(left: 10),
                      child: TextFields.defaultTextField(
                          themeModel: themeModel,
                          controller: pricePerKgController,
                          focusNode: pricePerKgFocus,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          labelText: 'Price per kG',
                          onSubmitted: (value) {},
                          enabled: !widget.model.isLoading &&
                              widget.model.pricePerKgEnabled,
                          isLoading: widget.model.isLoading,
                          error: !widget.model.validPricePerKg),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  vsync: this,
                  child: (!widget.model.validPricePerKg &&
                          widget.model.pricePerKgEnabled)
                      ? FadeIn(
                          child: Texts.helperText(
                              'Please enter a valid price per Kg', Colors.red),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Center(
              child: GestureDetector(
                onTap: !widget.model.isLoading
                    ? () {
                        widget.model.chooseImage(context);
                      }
                    : () {},
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: (!widget.model.validImage)
                                ? Colors.red
                                : Colors.transparent,
                            width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (!widget.model.networkImage)
                          ? FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: (widget.model.image ==
                                      'images/upload_image.png')
                                  ? AssetImage(widget.model.image)
                                  : FileImage(File(widget.model.image))
                                      as ImageProvider,
                              width: width / 3,
                              fit: BoxFit.cover,
                            )
                          : FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(widget.model.image),
                              width: width / 3,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: (!widget.model.validImage)
                  ? FadeIn(
                      child: Center(
                        child: Texts.helperText(
                            'Please choose an image', Colors.red),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          TextFields.defaultTextField(
              themeModel: themeModel,
              enabled: !widget.model.isLoading,
              controller: descriptionController,
              focusNode: descriptionFocus,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: null,
              labelText: 'Description',
              onSubmitted: (value) {},
              isLoading: widget.model.isLoading,
              error: !widget.model.validDescription),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validDescription)
                ? FadeIn(
                    child: Texts.helperText(
                        'Please enter a valid description', Colors.red),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextFields.defaultTextField(
                themeModel: themeModel,
                enabled: !widget.model.isLoading,
                controller: originController,
                focusNode: originFocus,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 2,
                maxLines: null,
                labelText: 'Origin',
                onSubmitted: (value) {},
                isLoading: widget.model.isLoading,
                error: !widget.model.validOrigin),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validOrigin)
                ? FadeIn(
                    child: Texts.helperText(
                        'Please enter a valid origin', Colors.red),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextFields.defaultTextField(
                themeModel: themeModel,
                controller: storageController,
                focusNode: storageFocus,
                enabled: !widget.model.isLoading,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 2,
                maxLines: null,
                labelText: 'Storage',
                onSubmitted: (value) {},
                isLoading: widget.model.isLoading,
                error: !widget.model.validStorage),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validStorage)
                ? FadeIn(
                    child: Texts.helperText(
                        'Please enter a valid storage', Colors.red),
                  )
                : SizedBox(),
          ),
          (widget.model.isLoading)
              ? Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Buttons.button(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Texts.headline3(
                            (widget.product == null) ? "Add" : "Update",
                            Colors.white),
                      )
                    ],
                  ),
                  onPressed: () {
                    widget.model.submit(
                        context,
                        titleController.text,
                        pricePerPieceController.text,
                        descriptionController.text,
                        originController.text,
                        storageController.text,
                        widget.product == null
                            ? null
                            : "products/" + widget.product!.reference,
                        pricePerKgController.text);
                  },
                  color: themeModel.accentColor),
        ],
      ),
    );
  }
}
