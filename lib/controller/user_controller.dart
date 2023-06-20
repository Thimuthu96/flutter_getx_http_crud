// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_http_crud/const/constants.dart';
import 'package:get_http_crud/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  final RxList userList = <User>[].obs;

  //----------fetch all users
  Future<void> fetchUsers() async {
    var url = Uri.parse('${baseUrl}api/users');
    late http.Response res;
    try {
      res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> userMap = jsonDecode(res.body);
        userList.assignAll(userMap.map((item) => User.fromMap(item)).toList());
      } else {
        return Future.error(
            'Something went wrong! Status code : ${res.statusCode}');
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }

  //--------------Add new user
  addUser(BuildContext context, User user) async {
    var url = Uri.parse('${baseUrl}api/users');
    late http.Response res;
    final dataJson = jsonEncode(user.toMap());
    try {
      ///--------send POST request
      res = await http.post(url, body: dataJson, headers: {
        'Content-Type': 'application/json',
      });
      //check response status code
      if (res.statusCode == 200) {
        debugPrint('POST request successful!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'User added successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      } else {
        debugPrint('POST request failed with status code : ${res.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Something went wrong!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }

  //-----------Update user
  updateUser(BuildContext context, int id, User user) async {
    final url = Uri.parse('${baseUrl}api/users/$id');
    late http.Response res;
    final dataJson = jsonEncode(user.toMap());
    try {
      //-------PUT request
      res = await http.put(
        url,
        body: dataJson,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        debugPrint('PUT request successful!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'User updated successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      } else {
        debugPrint('PUT request failed with status code : ${res.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Something went wrong!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }

  //---------- Delete user
  deleteUser(BuildContext context, int id) async {
    final url = Uri.parse('${baseUrl}api/users/$id');
    late http.Response res;
    try {
      //-------PUT request
      res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        debugPrint('User deleted successfully!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'User deleted successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      } else {
        debugPrint(
            'Delete request failed with status code : ${res.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Something went wrong!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }
}
