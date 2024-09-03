import 'dart:convert';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
    );
  }
  // make from document
  factory UserModel.fromDocument(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
    );
  }
}
