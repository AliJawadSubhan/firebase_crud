import 'package:firebase_crud/data/remote_data_source/firestor_helper.dart';
import 'package:firebase_crud/data/model/user_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();

  final bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    FireStoreHelper.createData(
                        context,
                        UserModel(
                          username: nameController.text,
                          bio: bioController.text,
                        ));
                    nameController.clear();
                    bioController.clear();
                  },
                  child: const Text('Create Mock (:')),
              Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'name',
                  ),
                ),
              ),
              Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    hintText: 'bio',
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              StreamBuilder<List<UserModel>>(
                  stream: FireStoreHelper.readData(),
                  builder: (context, snapshots) {
                    if (snapshots.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final userList = snapshots.data;
                    if (userList == null || userList.isEmpty) {
                      return const Text('No users found');
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: GestureDetector(
                              onLongPress: () async {
                                await FireStoreHelper.deleteData(
                                    context, UserModel(id: userList[index].id));
                              },
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newName =
                                        userList[index].username.toString();
                                    String newBio =
                                        userList[index].bio.toString();
                                    return AlertDialog(
                                      title: Text('Edit User'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            initialValue: newName,
                                            onChanged: (value) {
                                              newName = value;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Name',
                                            ),
                                          ),
                                          TextFormField(
                                            initialValue: newBio,
                                            onChanged: (value) {
                                              newBio = value;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Bio',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            // Update the data in Firestore using the newName and newBio variables
                                            await FireStoreHelper.updateData(
                                                context,
                                                UserModel(
                                                    username: newName,
                                                    bio: newBio,
                                                    id: userList[index].id));
                                            Navigator.pop(context);
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // FireStoreHelper.updateData(context);
                              },
                              child: Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ${userList[index].username ?? 'Unknown'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'bio: ${userList[index].bio ?? 'bio'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Id: ${userList[index].id ?? 'Id'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
