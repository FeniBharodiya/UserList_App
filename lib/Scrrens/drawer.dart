import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_list/Models/db_helper.dart';
import 'package:user_list/Models/dio_api_service.dart';
import 'package:user_list/Scrrens/favourite_list.dart';

class DrawerDemo extends StatefulWidget {
  const   DrawerDemo({super.key});

  @override
  State<DrawerDemo> createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  final UserController userController = Get.find<UserController>();

  Future<void> deleteUser() async {
    userController.isLoading.value = true;
    userController.userList.value = userController.searchList.value =
        await DatabaseHelper().deleteAllUserElement();
    userController.isLoading.value = false;
    print(userController.userList);
  }
  @override
  Widget build(BuildContext context) {
    return 
      Drawer(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
            Expanded(
                child: ListView(
                  
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      // ignore: sort_child_properties_last
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1499557354967-2b2d8910bcca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHByb2ZpbGUlMjBnaXJsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
                            radius: 50.0,
                            backgroundColor: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      iconColor: Colors.black,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Favourite'),
                      iconColor: Colors.yellow,
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const Favourite_list()
                        ),
                );
                      },
                    ),
                     const Spacer(),
                    
                  ],
                ),
              ),
              GestureDetector(
                    onTap: () async {
                      await deleteUser();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom:20),
                      child: Center(
                        child: Text(
                          "Clear data",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    ),
            ],
          ),
        ),
      );
    
  }
}
