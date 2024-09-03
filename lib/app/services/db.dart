import 'package:bento/app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference get currentUserRef {
    return userCollection.doc(FirebaseAuth.instance.currentUser!.uid);
  }

  CollectionReference get usersCollection => firebase.collection('users');

  CollectionReference<UserModel?> get userCollection => firebase
          .collection('users')
          .withConverter(fromFirestore: (snapshot, options) {
        return snapshot.exists ? UserModel.fromMap(snapshot.data()!) : null;
      }, toFirestore: (object, options) {
        return object!.toMap();
      });
}
