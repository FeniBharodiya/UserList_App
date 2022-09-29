// ignore_for_file: deprecated_member_use
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_list/Models/dio_api_service.dart';

class NetWorkConection {
  UserController userController = Get.find<UserController>();
  _showDialog(BuildContext context) {
    userController.isDialogOpen.value == true;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Icon(
                Icons.wifi_off_rounded,
                size: 70,
                color: Colors.lightBlue,
              ),
              content: const ListTile(
                title: Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "No Internet    (｡ ╯︵╰｡ )",
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(left: 16, top: 30),
                  child: Text(
                    "Please Check Your Internet Connectivity (-_-)",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              userController.isDialogOpen.value == false;
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                            // color: Colors.white,
                            // padding: EdgeInsets.only(
                            //     left: 45, right: 45, top: 15, bottom: 15),
                            child: const Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (userController.connectionStatus.value == 1) {
                              userController.isDialogOpen.value == false;
                              Navigator.of(context).pop();
                            } else {
                              print("No Network");
                            }
                          },
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          // color: Color.fromARGB(255, 187, 233, 255),
                          // padding: const EdgeInsets.only(
                          //     left: 30, right: 30, top: 15, bottom: 15),
                          child: const Text(
                            "RETRY",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ],
                  ),
                ),
              ]);
        });
  }

  void connectionCheckStatus(ConnectivityResult result, BuildContext context) {
    if (result == ConnectivityResult.none) {
      userController.connectionStatus.value = 0;
      if (userController.isDialogOpen.value == false) {
        _showDialog(context);
        print("connectiopn: 0");
      }
    } else {
      userController.connectionStatus.value = 1;
      print("connectiopn: 1");
    }
  }

  Future<void> checkstatus(BuildContext context) async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    // ignore: use_build_context_synchronously
    connectionCheckStatus(result, context);

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionCheckStatus(result, context);
    });
  }
}
