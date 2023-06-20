import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_http_crud/const/constants.dart';
import 'package:get_http_crud/controller/user_controller.dart';
import 'package:get_http_crud/model/user_model.dart';
import 'package:get_http_crud/views/widgets/confirmation_dialog.dart';
import 'package:get_http_crud/views/widgets/my_formfield.dart';
import 'package:http/http.dart' as http;

class UpdateUser extends StatefulWidget {
  final String data;
  final VoidCallback refreshCallBack;

  UpdateUser({
    required this.data,
    required this.refreshCallBack,
  });

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  var _id;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jsondata = jsonDecode(widget.data!);
    var id = jsondata["id"];
    nameController.text = jsondata["name"];
    emailController.text = jsondata["email"];
    contactNumberController.text = jsondata["contactNumber"];

    _id = id;
  }

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update user data'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Hi,',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'Edit user details as you prefered',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    MyFormFiled(
                      hint: 'Name here',
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Name must be need';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormFiled(
                      hint: 'Email here',
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Email must be need';
                        } else if (!_isValidEmail(text)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormFiled(
                      hint: 'Contact Number here',
                      inputType: TextInputType.number,
                      controller: contactNumberController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Contact number must be need';
                        } else if (text.length != 10) {
                          return 'Please enter valid contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // check validation
                          if (_formKey.currentState!.validate()) {
                            showAlertDialog(
                              context,
                              'Update User!',
                              'Are you sure to update this user details?',
                              () async {
                                await userController.updateUser(
                                  context,
                                  _id,
                                  User(
                                    name: nameController.text,
                                    email: emailController.text,
                                    contactNumber: contactNumberController.text,
                                  ),
                                );
                                widget.refreshCallBack();
                              },
                            );
                          } else {
                            setState(
                              () => _autovalidateMode = AutovalidateMode.always,
                            );
                          }
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }
}
