import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Models/db_helper.dart';
import '../Models/dio_api_service.dart';
import '../Models/user_model.dart';

class UserDetail extends StatefulWidget {
  @override
  final UserElement users;
  final int index;

  const UserDetail({super.key, required this.users, required this.index});
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final UserController usersController = Get.find<UserController>();
  final TextEditingController biocontroller = TextEditingController();
void _favoriteUser() {
    usersController.isFavorited.value = !usersController.isFavorited.value;
    widget.users.isFavourite = usersController.isFavorited.value;
    print("isFavorited: ${widget.users.isFavourite}");
  }
  
  UserElement? user;

  @override
   Widget build(BuildContext context) {
    biocontroller.text = widget.users.bio ?? '';
    usersController.isFavorited.value = widget.users.isFavourite ?? false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Get.back(result: user ?? widget.users);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: (usersController.isFavorited.value
                  ? Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                    )
                  : Icon(
                      Icons.star,
                      color: Colors.grey[700],
                    )),
              iconSize: 32,
              onPressed: _favoriteUser,
              
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(  
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset(
                "assets/profile.jpg",
                height: 125,
                width: 125,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "FirstName \n" "${widget.users.firstName ?? "ABC"}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        width: 80,
                        height: 80,
                      ),
                      Text(
                        "LastName \n" "${widget.users.lastName ?? "XYZ"}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Text(
                    "Email \n" "${widget.users.email ?? "NO"}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 100,
              width: 300,
              child: TextFormField(
                controller: biocontroller,
                onChanged: (value) {
                  widget.users.bio = biocontroller.text.toString();
                  print("Bio: ${widget.users.bio}");
                },
                decoration: InputDecoration(
                  labelText: "Bio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),  
                ),
              ),
            ),
            const SizedBox(height: 150),
            SizedBox(
              height: 50,
              width: 325,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  int updatedId = await DatabaseHelper()
                      .update(usersController.userList[widget.index]);
                  usersController.userList.value = usersController.searchList
                      .value = await DatabaseHelper().getAllUserElement();
                  print(
                      "isFavorited: ${usersController.userList[widget.index].isFavourite}");
                  user = usersController.userList[widget.index];
                  Get.back(result: user ?? widget.users);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
