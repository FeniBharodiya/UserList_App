import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:user_list/Models/user_model.dart';
import 'package:get/state_manager.dart';
import 'package:user_list/Models/db_helper.dart';

class ApiServices {
  final UserController userController = Get.put(UserController());
  var dio = Dio();

  Future<List<UserElement>> fatchUsers() async {
    print(("fatchUsers called"));
    try {
      userController.isLoading.value = true;
      final Response response = await dio.get(
          "https://verified-mammal-79.hasura.app/api/rest/users",
          queryParameters: {"since": 0});
      userController.isLoading.value = false;
      if (response.statusCode == 200) {
        userController.userList.value = userController.searchList.value =
            userFromJson(jsonEncode(response.data)).users ?? [];
        return userController.userList;
      } else {
        throw Exception('Enable to load users');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}

class UserController extends GetxController {
  RxBool isDialogOpen = false.obs;
  RxBool isLoading = false.obs;
  RxInt connectionStatus = 0.obs;
  RxBool isFavorited = false.obs;
  static RxBool isFavouriteLoading = false.obs;

  RxList<UserElement> userList = <UserElement>[].obs;
  RxList<UserElement> favouriteList = <UserElement>[].obs;
  RxList<UserElement> searchList = <UserElement>[].obs;

  var dio = Dio();

  Future<List<UserElement>> checkDatabaseStatusAndGetUserList() async {
    isLoading.value = true;
    userList.value =
        searchList.value = await DatabaseHelper().getAllUserElement();
    isLoading.value = false;
    print("UserList from Database $userList ");
    if (userList.isEmpty) {
      await ApiServices().fatchUsers();
      //inserting data in list
      await DatabaseHelper().insert(userList);
      print("UserList from API $userList");
      return searchList;
    }
    return searchList;
  }
}
