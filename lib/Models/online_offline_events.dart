import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  StreamSubscription? connection;
  bool isoffline = false;

  @override
  void initState() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
          alignment: Alignment.center,
          child: Column(children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30),
              color: isoffline ? Colors.red : Colors.lightGreen,
              padding: EdgeInsets.all(10),
              child: Text(
                isoffline ? "Device is Offline" : "Device is Online",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       var result = await Connectivity().checkConnectivity();
            //       if (result == ConnectivityResult.mobile) {
            //         print("Internet connection is from Mobile data");
            //       } else if (result == ConnectivityResult.wifi) {
            //         print("internet connection is from wifi");
            //       } else if (result == ConnectivityResult.ethernet) {
            //         print("internet connection is from wired cable");
            //       } else if (result == ConnectivityResult.bluetooth) {
            //         print("internet connection is from bluethooth threatening");
            //       } else if (result == ConnectivityResult.none) {
            //         print("No internet connection");
            //       }
            //     },
            //     child: Text("Check Your Internet Connection", style: TextStyle(fontSize: 0, color: Colors.white),)
            //     )
          ])),
    );
  }
}
