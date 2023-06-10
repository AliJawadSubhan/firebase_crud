import 'package:firebase_crud/model/remote_data_source/firestor_helper.dart';
import 'package:firebase_crud/model/user_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

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
                      itemBuilder: (c, i) {
                        return SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userList[i].username ?? 'username'),
                              SizedBox(
                                height: 12,
                              ),
                              Text(userList[i].bio.toString()),
                              Divider(),
                            ],
                          ),
                        );
                      },
                      itemCount: userList.length,
                    ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
