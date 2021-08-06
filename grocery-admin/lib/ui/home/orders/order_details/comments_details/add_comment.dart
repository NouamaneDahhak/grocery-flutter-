import 'package:flutter/material.dart';
import 'package:grocery_admin/models/state_models/add_comment_model.dart';
import 'package:grocery_admin/models/state_models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/text_fields.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

class AddComment extends StatefulWidget {
  final String? comment;
  final String path;
  final AddCommentModel model;



  AddComment._({required this.model,required this.path,this.comment});

  static void create(BuildContext context, {required String path, String? comment}) {
    final database = Provider.of<Database>(context, listen: false);

     showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ChangeNotifierProvider<AddCommentModel>(
            create: (context) => AddCommentModel(database: database),
            child: Consumer<AddCommentModel>(
              builder: (context, model, _) {
                return AddComment._(
                  model: model,
                  path: path,
                  comment: comment,
                );
              },
            ),
          );
        });
  }



  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> with TickerProviderStateMixin{

  TextEditingController commentController = TextEditingController();

  FocusNode commentFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    if(widget.comment!=null){
       commentController = TextEditingController(text: widget.comment);
    }
  }

  @override
  Widget build(BuildContext context) {



    final themeModel = Provider.of<ThemeModel>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: themeModel.secondBackgroundColor),
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Align(
            alignment: Alignment.center,
            child: Texts.headline3(
                ((widget.comment == null) ? "Add" : "Edit") + " Comment",
                themeModel.textColor),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: TextFields.defaultTextField(
                changeBackColor: true,
                themeModel: themeModel,
                controller: commentController,
                focusNode: commentFocus,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 2,
                maxLines: null,
                labelText: "Comment",
                onSubmitted: (value) {},
                error: !widget.model.validComment,
                isLoading: widget.model.isLoading),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: (!widget.model.validComment)
                ? FadeIn(
              child: Texts.helperText(
                  'Please enter a valid comment', Colors.red),
            )
                : SizedBox(),
          ),


          Align(
            alignment: Alignment.center,
            child: (widget.model.isLoading)
                ? Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,

                ),
                child: CircularProgressIndicator(),
              ),
            )
                : Container(
              width: double.infinity,
              child: Buttons.button(
                //margin: EdgeInsets.all(0),
                  widget: Padding(padding: EdgeInsets.only(left: 10,right: 10),
                    child: Texts.headline3(
                        (widget.comment == null) ? "Add" : "Update",
                        Colors.white),
                  ),
                  onPressed: () async {
                    await widget.model.submit(
                        context, commentController.text,widget.path);


                    Navigator.pop(context);
                  },
                  color: themeModel.accentColor),
            ),
          )
        ],
      ),
    );
  }
}
