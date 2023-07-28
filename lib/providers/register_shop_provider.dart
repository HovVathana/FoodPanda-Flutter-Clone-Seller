import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_seller/common/firebare_storage_repository.dart';
import 'package:foodpanda_seller/models/address.dart';
import 'package:image_picker/image_picker.dart';

class RegisterShopProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;

  String? _shopName;
  String? get shopName => _shopName;

  String? _shopDescription;
  String? get shopDescription => _shopDescription;

  String? _shopImage;
  String? get shopImage => _shopImage;

  Address? _shopAddress;
  Address? get shopAddress => _shopAddress;

  RegisterShopProvider() {
    checkIfAddressExist();
  }

  Future checkIfAddressExist() async {
    await firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      _shopName =
          doc.data().toString().contains('shopName') ? doc.get('shopName') : '';

      _shopDescription = doc.data().toString().contains('shopDescription')
          ? doc.get('shopDescription')
          : '';
      _shopImage = doc.data().toString().contains('shopImage')
          ? doc.get('shopImage')
          : '';

      String latitude = doc.data().toString().contains('latitude')
          ? doc.get('latitude').toString()
          : '';

      String longitude = doc.data().toString().contains('longitude')
          ? doc.get('longitude').toString()
          : '';

      if (latitude.isNotEmpty && longitude.isNotEmpty) {
        _shopAddress = Address(
          houseNumber: doc.data().toString().contains('houseNumber')
              ? doc.get('houseNumber')
              : '',
          street:
              doc.data().toString().contains('street') ? doc.get('street') : '',
          area: doc.data().toString().contains('area') ? doc.get('area') : '',
          latitude: double.parse(latitude),
          longitude: double.parse(longitude),
          province: doc.data().toString().contains('province')
              ? doc.get('province')
              : '',
          floor:
              doc.data().toString().contains('floor') ? doc.get('floor') : '',
        );
      }

      if (_shopName!.isEmpty ||
          _shopDescription!.isEmpty ||
          _shopImage!.isEmpty ||
          latitude.isEmpty ||
          longitude.isEmpty) {
        _isRegistered = false;
      } else {
        _isRegistered = true;
      }
      notifyListeners();
    });
  }

  Future registerShop({
    required String shopName,
    required String shopDescription,
    required Address address,
    XFile? image,
    String? imageUrl,
  }) async {
    String shopImage;
    if (image != null) {
      shopImage = await storeFileToFirebase(
        'seller/${firebaseAuth.currentUser!.uid}/profile',
        File(image.path),
      );
    } else {
      shopImage = imageUrl!;
    }

    await firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .set(
      {
        "shopName": shopName,
        "shopDescription": shopDescription,
        "shopImage": shopImage,
        "rating": 0,
        "totalRating": 0,
        'area': address.area,
        'floor': address.floor,
        'houseNumber': address.houseNumber,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'province': address.province,
        'street': address.street,
      },
      SetOptions(merge: true),
    );
    _isRegistered = true;
    _shopName = shopName;
    _shopDescription = shopDescription;
    _shopImage = shopImage;
    _shopAddress = address;
    notifyListeners();
  }
}
