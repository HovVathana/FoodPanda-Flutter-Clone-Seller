import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_seller/models/order.dart' as model;

class OrderController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<model.Order>> fetchOrder() {
    return firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
      (event) {
        List<model.Order> ordersList = [];
        for (var document in event.docs) {
          model.Order tempOrder = model.Order.fromMap(document.data());
          if (!tempOrder.isRiderAccept && !tempOrder.isCancelled) {
            ordersList.add(tempOrder);
          }
        }
        return ordersList;
      },
    );
  }

  Future<List<model.Order>> fetchOrderHistory() async {
    List<model.Order> ordersList = [];
    var orderSnapshot = await firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .orderBy('time', descending: true)
        .get();
    for (var tempData in orderSnapshot.docs) {
      model.Order tempOrder = model.Order.fromMap(tempData.data());
      ordersList.add(tempOrder);
    }

    return ordersList;
  }

  Future acceptOrder({
    required model.Order order,
  }) async {
    await firestore
        .collection('sellers')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isShopAccept": true,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('users')
        .doc(order.user.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isShopAccept": true,
      },
      SetOptions(merge: true),
    );

    await firestore.collection('orders').doc(order.id).set(order.toMap());

    order.isShopAccept = true;
  }
}
