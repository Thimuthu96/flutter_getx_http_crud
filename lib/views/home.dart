import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_http_crud/controller/user_controller.dart';
import 'package:get_http_crud/model/user_model.dart';
import 'package:get_http_crud/views/add_user.dart';
import 'package:get_http_crud/views/update_user.dart';
import 'package:get_http_crud/views/widgets/confirmation_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome User Registry'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddUser(refreshCallBack: userController.fetchUsers),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: Column(
        children: [
          userList(),
        ],
      ),
    );
  }

  Widget userList() {
    return Expanded(
      child: Obx(
        () {
          if (userController.userList.isEmpty) {
            return const Center(
              child: Text('No data found!'),
            );
          } else {
            return AnimationLimiter(
              child: ListView.builder(
                scrollDirection:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                itemCount: userController.userList.length,
                itemBuilder: (BuildContext context, int index) {
                  User user = userController.userList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 500 + index * 20),
                    child: SlideAnimation(
                      horizontalOffset: 400.0,
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateUser(
                                  data: jsonEncode({
                                    "id": user.id,
                                    "name": user.name,
                                    "email": user.email,
                                    "contactNumber": user.contactNumber,
                                  }),
                                  refreshCallBack: userController.fetchUsers,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.account_circle_outlined),
                        ),
                        title: Text(user.name.toString()),
                        subtitle: Text(user.email.toString()),
                        trailing: IconButton(
                          onPressed: () {
                            showAlertDialog(context, 'Delete user!',
                                'Are you sure to delete this user?', () async {
                              await userController.deleteUser(
                                context,
                                int.parse(user.id.toString()),
                              );
                              userController.fetchUsers();
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
