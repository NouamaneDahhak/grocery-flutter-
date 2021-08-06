import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/blocs/products_reader_bloc.dart';
import 'package:grocery/models/data_models/product.dart';
import 'package:grocery/models/state_models/theme_model.dart';
import 'package:grocery/services/auth.dart';
import 'package:grocery/services/database.dart';
import 'package:grocery/ui/product_details/product_details.dart';
import 'package:grocery/widgets/cards.dart';
import 'package:grocery/widgets/dialogs.dart';
import 'package:grocery/widgets/fade_in.dart';
import 'package:grocery/widgets/texts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductReader extends StatefulWidget {
  final ProductsReaderBloc bloc;

  ProductReader({required this.bloc});

  static create(BuildContext context, {required String category}) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return Provider<ProductsReaderBloc>(
        create: (context) => ProductsReaderBloc(
            database: database, auth: auth, category: category),
        child: Consumer<ProductsReaderBloc>(
          builder: (context, bloc, _) {
            return ProductReader(bloc: bloc);
          },
        ),
      );
    }));
  }

  @override
  _ProductReaderState createState() => _ProductReaderState();
}

class _ProductReaderState extends State<ProductReader> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.loadProducts(10);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    final themeModel = Provider.of<ThemeModel>(context);

    ///Add products if we are at bottom edge
    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3(
            widget.bloc.category.replaceFirst(
                widget.bloc.category[0], widget.bloc.category[0].toUpperCase()),
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
      body: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (_scrollController.position.extentAfter == 0) {
                widget.bloc.loadProducts((width ~/ 180) *  (height ~/ 180));
              }
            }
            return false;
          },
          child: StreamBuilder<List<Product>>(
            stream: widget.bloc.productsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                widget.bloc.savedProducts = snapshot.data!;
                List<Product> products = snapshot.data!;

                if (snapshot.data!.length == 0) {
                  ///If no product
                  return Center(
                    child: FadeIn(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'images/state_images/nothing_found.svg',
                            width: width * 0.5,
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
                  ///If there are products
                  return GridView.count(
                    controller: _scrollController,
                    crossAxisCount: width ~/ 180,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 16,
                      right: 16,
                    ),
                    children: List.generate(snapshot.data!.length, (index) {
                      return FadeIn(
                        child: Cards.product(
                            themeModel: themeModel,
                            product: products[index],
                            width: width,
                            onTap: () {
                              ProductDetails.create(context, products[index])
                                  .then((value) {
                                if (value != null) {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialogs.success(
                                        context,
                                        message:
                                            "Congratulations!\nYour order is placed!"),
                                  ).then((value) {
                                    widget.bloc.removeCart();
                                  });
                                }
                              });
                            }),
                      );
                    }),
                  );
                }
              } else if (snapshot.hasError) {
                ///If there is an error
                return Center(
                  child: FadeIn(
                    child: SvgPicture.asset(
                      'images/state_images/error.svg',
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
          )),
    );
  }
}
