import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/model/user_model.dart';
import 'package:flutter/material.dart';

class FireStoreHelper {
// read
  static Stream<List<UserModel>> readData() {
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((querySnapshot) {
      List<UserModel> userList = [];
      for (var document in querySnapshot.docs) {
        UserModel user = UserModel.fromFirebase(document);
        userList.add(user);
      }
      return userList;
    });
  }

  // create
  static Future<void> createData(BuildContext context, UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    try {
      final newUser = UserModel(
        username: user.username,
        bio: user.bio,
      ).toFirebase();
      await userCollection.add(newUser);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding document'),
        ),
      );
    }
  }
}
