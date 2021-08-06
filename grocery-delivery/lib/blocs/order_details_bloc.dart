import 'dart:async';

import 'package:delivery/models/data_models/address.dart';
import 'package:delivery/models/data_models/order.dart';
import 'package:delivery/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

import 'package:map_launcher/map_launcher.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailsBloc {
  final String path;
  final Database database;

  OrderDetailsBloc({required this.database, required this.path});

  // ignore: close_sinks
  StreamController<bool> itemsController = BehaviorSubject();

  // ignore: close_sinks
  StreamController<bool> paymentController = BehaviorSubject();

  // ignore: close_sinks
  StreamController<bool> addressController = BehaviorSubject();

  // ignore: close_sinks
  StreamController<bool> shippingMethodController = BehaviorSubject();

  // ignore: close_sinks
  StreamController<bool> couponController = BehaviorSubject();

  // ignore: close_sinks
  StreamController<bool> commentsController = BehaviorSubject();

  //Get order
  Stream<Order> getOrder() {
    return database.getDataFromDocument(path).map(
        (snapshot) => Order.fromMap(snapshot.data() as Map, snapshot.id, path));
  }

  Future<void> showMap(Address address) async {
    String stringAddress = address.toString();

    try {
      List<Location> locations = await locationFromAddress(stringAddress);

      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isNotEmpty) {
        await availableMaps.first.showDirections(
          destination:
              Coords(locations.first.latitude, locations.first.longitude),
          destinationTitle: stringAddress,
        );
      } else {
        Fluttertoast.showToast(
            msg: "No available Maps App installed in this device!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Can\'t find this location!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
