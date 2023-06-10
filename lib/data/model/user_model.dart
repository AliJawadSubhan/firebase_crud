import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? username;
  final String? bio;

  UserModel({this.username, this.bio});

  factory UserModel.fromFirebase(DocumentSnapshot data) {
    var snapshot = data.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot['username'],
      bio: snapshot['bio'],
    );
  }

  Map<String, dynamic> toFirebase() => {
        "username": username,
        "bio": bio,
      };
}

final newUser = UserModel().toFirebase();
