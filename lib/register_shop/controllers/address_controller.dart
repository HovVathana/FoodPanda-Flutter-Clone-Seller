import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_seller/models/address.dart';

class AddressController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future saveAddressToFirestore({required Address address}) async {
    await firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .set(
      {
        'area': address.area,
        'floor': address.floor,
        'houseNumber': address.houseNumber,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'province': address.province,
        'street': address.street,
      },
      SetOptions(merge: true),
    ).catchError((error) {
      print(error);
    });
  }
}
