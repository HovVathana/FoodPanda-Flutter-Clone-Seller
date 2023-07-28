import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foodpanda_seller/common/firebare_storage_repository.dart';
import 'package:foodpanda_seller/models/category.dart';
import 'package:foodpanda_seller/models/customize.dart';
import 'package:foodpanda_seller/models/food.dart';
import 'package:image_picker/image_picker.dart';

class FoodController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addNewCategory({
    required String title,
    required String subtitle,
    String? id,
  }) async {
    final DocumentReference ref;
    if (id != null) {
      ref = firestore
          .collection('sellers')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('categories')
          .doc(id);
    } else {
      ref = firestore
          .collection('sellers')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('categories')
          .doc();
    }

    await ref.set({
      'title': title,
      'subtitle': subtitle,
      'id': ref.id,
      'isPublished': true,
    }).catchError((error) {
      debugPrint(error);
    });
  }

  Future deleteCategory({
    required String id,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(id);

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }

  Future changeIsPublished(
      {required String id, required bool isPublished}) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(id);

    await ref.set(
      {
        "isPublished": isPublished,
      },
      SetOptions(merge: true),
    ).catchError((error) {
      debugPrint(error);
    });
  }

  Stream<List<Category>> fetchCategory() {
    return firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .snapshots()
        .map(
      (event) {
        List<Category> categories = [];
        for (var document in event.docs) {
          categories.add(Category.fromMap(document.data()));
        }
        return categories;
      },
    );
  }

  Future addNewFood({
    required String categoryId,
    required String name,
    required String description,
    required double price,
    required double comparePrice,
    required XFile? imageFile,
    String? imageUrl,
    String? foodId,
  }) async {
    final DocumentReference ref;
    String foodImage;

    if (foodId != null) {
      ref = firestore
          .collection('sellers')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('foods')
          .doc(foodId);
    } else {
      ref = firestore
          .collection('sellers')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('foods')
          .doc();
    }

    if (imageUrl != null) {
      foodImage = imageUrl;
    } else {
      foodImage = await storeFileToFirebase(
        'seller/${firebaseAuth.currentUser!.uid}/$categoryId/${ref.id}',
        File(imageFile!.path),
      );
    }

    await ref.set({
      'id': ref.id,
      'name': name,
      'description': description,
      'price': price,
      'comparePrice': comparePrice,
      'image': foodImage,
      'isPublished': true,
    }).catchError((error) {
      debugPrint(error);
    });
  }

  Stream<List<Food>> fetchFood({required String categoryId}) {
    return firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .snapshots()
        .map(
      (event) {
        List<Food> foods = [];
        for (var document in event.docs) {
          foods.add(Food.fromMap(document.data()));
        }
        return foods;
      },
    );
  }

  Future<Food?> fetchFoodById({
    required String categoryId,
    required String id,
  }) async {
    var foodData = await firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(id)
        .get();

    Food? food;
    if (foodData.data() != null) {
      food = Food.fromMap(foodData.data()!);
    }

    return food;
  }

  Future deleteFood({
    required String categoryId,
    required String id,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(id);

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }

  Future changeIsPublishedFood({
    required String categoryId,
    required String id,
    required bool isPublished,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(id);

    await ref.set(
      {
        "isPublished": isPublished,
      },
      SetOptions(merge: true),
    ).catchError((error) {
      debugPrint(error);
    });
  }

  Future addCustomize({
    required String categoryId,
    required String foodId,
    required Customize customize,
  }) async {
    final DocumentReference ref;

    ref = firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(foodId)
        .collection('customize')
        .doc();

    await ref.set({
      'id': ref.id,
      'choices': customize.choices.map((choice) {
        return choice.toMap();
      }).toList(),
      'title': customize.title,
      'isRequired': customize.isRequired,
      'isRadio': customize.isRadio,
      'isVariation': customize.isVariation,
      'selectAmount': customize.selectAmount,
    }).catchError((error) {
      debugPrint(error);
    });
  }
}
