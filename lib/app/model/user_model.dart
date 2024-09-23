import 'package:bento/app/model/gridItem_model.dart';

class UserModel {
  String? uid;
  String? bio;
  String? email;
  String? name;
  String? photoUrl;
  List<GridItem> gridItems;

  UserModel({
    this.uid,
    this.bio,
    this.email,
    this.name,
    this.photoUrl,
    this.gridItems = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'bio': bio,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'gridItems': gridItems.map((item) => item.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String?,
      bio: map['bio'] as String?,
      email: map['email'] as String?,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      gridItems: List<GridItem>.from(
        (map['gridItems'] as List<dynamic>)
            .map((item) => GridItem.fromMap(item as Map<String, dynamic>)),
      ),
    );
  }

  factory UserModel.fromDocument(Map<String, dynamic> map) {
    return UserModel.fromMap(map);
  }
}
