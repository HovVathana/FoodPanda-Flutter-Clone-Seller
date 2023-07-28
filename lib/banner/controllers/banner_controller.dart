import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_seller/common/firebare_storage_repository.dart';
import 'package:foodpanda_seller/models/banner.dart' as model;
import 'package:image_picker/image_picker.dart';

class BannerController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future createBanner({
    required XFile image,
    required String description,
  }) async {
    final DocumentReference ref;

    ref = firestore.collection('banners').doc();

    String imageUrl = await storeFileToFirebase(
      'seller/${firebaseAuth.currentUser!.uid}/banner/${ref.id}',
      File(image.path),
    );

    model.Banner banner = model.Banner(
      id: ref.id,
      imageUrl: imageUrl,
      description: description,
      creatorId: firebaseAuth.currentUser!.uid,
      shopListId: [firebaseAuth.currentUser!.uid],
      isApproved: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await ref.set(banner.toMap()).catchError((error) {
      debugPrint(error);
    });
  }

  Stream<List<model.Banner>> fetchBanner() {
    return firestore
        .collection('banners')
        .where('creatorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map(
      (event) {
        List<model.Banner> banners = [];
        for (var document in event.docs) {
          banners.add(model.Banner.fromMap(document.data()));
        }
        return banners;
      },
    );
  }

  Future deleteBanner({
    required String bannerId,
  }) async {
    final DocumentReference ref;
    ref = firestore.collection('banners').doc(bannerId);

    await deleteFileStorage(
        'seller/${firebaseAuth.currentUser!.uid}/banner/$bannerId');

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }
}
