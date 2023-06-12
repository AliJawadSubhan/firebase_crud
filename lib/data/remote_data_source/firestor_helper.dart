// import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/data/model/user_model.dart';
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
    final documentid = userCollection.doc().id;
    final documentref = userCollection.doc(documentid);
    try {
      final newUser = UserModel(
        username: user.username,
        bio: user.bio,
        id: documentid,
      ).toFirebase();
      await documentref.set(newUser);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding document'),
        ),
      );
    }
  }

  //update data
  static Future<void> updateData(BuildContext context, UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final documentref = userCollection.doc(user.id);
    try {
      final newUser = UserModel(
        username: user.username,
        bio: user.bio,
        id: user.id,
      ).toFirebase();
      await documentref.update(newUser);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding document' + error.toString()),
        ),
      );
    }
  }

  // delete Data
  static Future<void> deleteData(BuildContext context, UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    try {
      userCollection.doc(user.id).delete();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding document' + error.toString()),
        ),
      );
    }
  }
}
