import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/helpers/project_configuration.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/transparent_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'landing.dart';

class SplashScreen extends StatelessWidget {
  final AuthBase auth;
  final Database database;

  SplashScreen({required this.auth, required this.database});

  Future<void> precacheImages(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1500));

    ///Precache images for better performance
    ///Precache png images
    await Future.forEach(ProjectConfiguration.pngImages, (image) async {
      await precacheImage(AssetImage(image as String), context);
    });

    ///Precache svg images
    await Future.forEach(ProjectConfiguration.svgImages, (image) async {
      await precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, image as String),
          context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: precacheImages(context),
        builder: (context, verificationSnapshot) {
          return StreamBuilder<User?>(
              stream: auth.onAuthStateChanged,
              builder: (context, snapshot) {
                if (verificationSnapshot.connectionState ==
                    ConnectionState.done) {
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    ///Check if the user is a delivery boy
                    Future.delayed(Duration.zero).then((value) async {
                      if (snapshot.hasData) {
                        try {
                          DocumentSnapshot document =
                              (await database.getFutureDataFromDocument(
                                  "delivery_boys/" + snapshot.data!.email!));

                          Map? data = document.data() as Map?;

                          if (data == null) {
                            throw Exception();
                          }
                        } catch (e) {
                          await auth.signOut();
                        }
                      }
                      Landing.create(context);
                    });
                  });
                }

                return Center(
                  child: FadeInImage(
                    image: AssetImage(ProjectConfiguration.logo),
                    placeholder: MemoryImage(kTransparentImage),
                    width: 100,
                    height: 100,
                  ),
                );
              });
        },
      ),
    );
  }
}
