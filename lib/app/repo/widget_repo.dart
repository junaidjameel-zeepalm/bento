import 'package:bento/app/model/gridItem_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WidgetRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<GridItem>> fetchUserWidgets(String uid) async {
    QuerySnapshot widgetSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .orderBy('position')
        .get();

    return widgetSnapshot.docs.map((doc) {
      return GridItem.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> updateWidgetText(
      String uid, String itemId, String newText) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .update({'text': newText});
  }

  Future<void> updateSectionText(
      String uid, String itemId, String newText) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .update({'sectionTile': newText});
  }

  Future<void> reorderWidgets(String uid, List<GridItem> items) async {
    WriteBatch batch = _firestore.batch();
    for (int i = 0; i < items.length; i++) {
      GridItem updatedItem = items[i].copyWith(position: i);
      DocumentReference itemRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('widgets')
          .doc(updatedItem.id);

      batch.update(itemRef, updatedItem.toMap());
    }
    await batch.commit();
  }

  Future<void> addWidget(String uid, GridItem item) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(item.id)
        .set(item.toMap());
  }

  Future<void> deleteWidget(String uid, String itemId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .delete();
  }

  Future<void> updateWidgetShape(
      String uid, String itemId, String shapeName) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .update({'shape': shapeName});
  }
}
