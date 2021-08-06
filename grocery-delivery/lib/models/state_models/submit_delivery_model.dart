import 'dart:io';
import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class SubmitDeliveryModel with ChangeNotifier {
  final Database database;
  final AuthBase auth;
  final String path;

  SubmitDeliveryModel(
      {required this.database, required this.auth, required this.path});

  String image = 'images/upload_image.png';

  bool networkImage = false;

  bool validComment = true;
  bool validImage = true;

  bool isLoading = false;

  Future<void> chooseImage(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      image = result.files.single.path!;
      networkImage = false;
      notifyListeners();
    } else {
      // User canceled the picker
    }
  }

  Future<void> submit(
      BuildContext context, String comment, bool declineAction) async {
    if (verifyInputs(comment)) {
      isLoading = true;
      notifyListeners();

      try {
        DateTime dateTime = DateTime.now();

        if (!networkImage) {
          FirebaseStorage firebaseStorage = FirebaseStorage.instance;
          String id = dateTime.year.toString() +
              dateTime.month.toString() +
              dateTime.day.toString() +
              dateTime.hour.toString() +
              dateTime.minute.toString() +
              dateTime.microsecond.toString();

          File imageFile = File(image);

          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(imageFile.path);
          File compressedImage = await FlutterNativeImage.compressImage(
              imageFile.path,
              quality: 100,
              targetWidth: 400,
              targetHeight:
                  (properties.height! * 400 / properties.width!).round());

          UploadTask task = firebaseStorage
              .ref()
              .child(
                  'delivery_boys/${auth.email}/${id + image.split('/').last}')
              .putFile(compressedImage);

          late String url;

          await task.whenComplete(() async {
            url = await task.snapshot.ref.getDownloadURL();
          });

          image = url;
          networkImage = true;
        }

        await database.updateData({
          "delivery_comment": {
            "image": image,
            "comment": comment,
          }
        }, path);

        isLoading = false;
        notifyListeners();

        Navigator.pop(context);

        Navigator.pop(
            context,
            HistoryItem(
                date: dateTime.year.toString() +
                    '-' +
                    ((dateTime.month < 10)
                        ? "0" + dateTime.month.toString()
                        : dateTime.month.toString()) +
                    '-' +
                    ((dateTime.day < 10)
                        ? "0" + dateTime.day.toString()
                        : dateTime.day.toString()) +
                    " " +
                    ((dateTime.hour < 10)
                        ? "0" + dateTime.hour.toString()
                        : dateTime.hour.toString()) +
                    ':' +
                    ((dateTime.minute < 10)
                        ? "0" + dateTime.minute.toString()
                        : dateTime.minute.toString()),
                order: path.split('/').last,
                status: declineAction ? "Declined" : "Delivered",
                comment: comment,
                image: image));
      } catch (e) {
        if (e is FirebaseException) {
          FirebaseException exception = e;

          showDialog(
              context: context,
              builder: (context) =>
                  Dialogs.error(context, message: exception.message));
        }
        isLoading = false;
        notifyListeners();
      }
    }
  }

  bool verifyInputs(String title) {
    if (title.replaceAll(" ", "").isEmpty) {
      validComment = false;
    } else {
      validComment = true;
    }

    if (image == 'images/upload_image.png') {
      validImage = false;
    } else {
      validImage = true;
    }

    if (!validComment || !validImage) {
      notifyListeners();
    }

    return validComment && validImage;
  }
}
