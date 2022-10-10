import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_list/Models/db_helper.dart';
import 'package:user_list/Models/dio_api_service.dart';
import 'package:user_list/Scrrens/drawer.dart';
import 'package:user_list/Scrrens/user_details.dart';
import '../Models/internet_model.dart';
import '../Models/user_model.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final UserController userController = Get.put(UserController());
  //GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  void initState() {
    NetWorkConection().checkstatus(context);
    userController.checkDatabaseStatusAndGetUserList();
    super.initState();
  }

  Future<void> searchUser(String value) async {
    if (value != '') {
      userController.searchList.value = await DatabaseHelper().search(value);
    } else {
      userController.searchList.value = await DatabaseHelper().search('');
    }
  }

  // getData() async {
  //   var res = await http.get(
  //       Uri.parse('https://verified-mammal-79.hasura.app/api/rest/users/'));
  //   data = jsonDecode(res.body);
  //   print(data);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.05,
        backgroundColor: Colors.white60,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: TextField(
              onChanged: (value) {
                searchUser(value);
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                contentPadding: EdgeInsets.only(left: 10, top: 6),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: userController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : userController.searchList.isEmpty
                  ? const Center(
                      child: Text('NO USER FOUND (｡•́︿•̀｡)'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: userController.searchList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              onTap: () async {
                                UserElement result = await Get.to(UserDetail(
                                  users: userController.searchList[index],
                                  index: index,
                                ));
                                userController.searchList[index] = result;
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.asset(
                                  "assets/profile.jpg",
                                ),
                              ),
                              title: Text(
                                '${userController.searchList[index].firstName} ${userController.searchList[index].lastName}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                userController.searchList[index].bio ??
                                    "Lorem Ipsum is simply..",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                              trailing: (userController
                                              .searchList[index].isFavourite !=
                                          null &&
                                      userController
                                              .searchList[index].isFavourite ==
                                          true
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.star,
                                      color: Colors.grey,
                                      size: 30,
                                    )),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(),
                        );
                      },
                    ),
        ),
      ),
      drawer: const DrawerDemo(),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   Future<List<User>> _getUsers() async {
//      var data = await http.get(Uri.parse("https://verified-mammal-79.hasura.app/api/rest/users/0"));
//      var jsonData = json.decode(data.body);

//      List<User> users= [];
//      for(var u in jsonData) {
//        User user = User(created_at: '', email: '', first_name: '',
//        //id: null,
//         last_name: '', updated_at: ''

//       );
//        users.add(user);
//      }

//      //print("the count is " + users.length.toString());

//      return users;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: Container(
//          child: FutureBuilder(
//            future: _getUsers(),
//            builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
//              if(asyncSnapshot.data == null){
//                return Center(
//                  child: Container(
//                    child: CircularProgressIndicator(),
//                  ),
//                );
//              } else {
//                return ListView.builder(
//                  itemCount: asyncSnapshot.data.length,
//                  itemBuilder: (BuildContext context, int index) {
//                    return ListTile(
//                      title: Text(asyncSnapshot.data[index].name),
//                      leading: CircleAvatar(
//                        backgroundImage: NetworkImage(
//                          asyncSnapshot.data[index].picture + asyncSnapshot.data[index].index.toString() + ".jpg"
//                        ),
//                      ),
//                      subtitle: Text(asyncSnapshot.data[index].email) ,
//                      onTap: () {
//                        Navigator.push(context,
//                          new MaterialPageRoute(builder: (context) => DetailPage(asyncSnapshot.data[index]))
//                        );
//                      },
//                    );
//                  },
//                );
//              }
//            },
//          ),
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// class DetailPage extends StatelessWidget {

//   final User user;

//   DetailPage(this.user);

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(

//       body: Container(
//         child: Center(
//           child: Text(this.user.first_name),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController _nameController = TextEditingController();
//   var myText = "Change Me";
//   var url = "https://verified-mammal-79.hasura.app/api/rest/users/";
//   var data;

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   getData() async {
//     var res = await http
//         .get(Uri.parse('https://verified-mammal-79.hasura.app/api/rest/users/'));
//     data = jsonDecode(res.body);
//     print(data);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: 
//         // data != null
//         //     ?  Center(
//         //         child: CircularProgressIndicator(),
//         //       )
//         //     :
//              ListView.builder(
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: ListTile(
//                       title: Text(data[index]["email"]),
//                       subtitle: Text("ID: ${data[index]["id"]}"),
//                      // leading: Image.network(data[index]["thumbnailUrl"]),
//                     ),
//                   );
//                 },
//                 itemCount: data?.length,
//               )
           
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           myText = _nameController.text;
//           setState(() {});
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:ffi';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:http/http.dart' as http;
// import '../Models/user_model.dart';

// class home extends StatefulWidget {
//   const home({super.key});

//   @override
//   State<home> createState() => _homeState();
// }

// class _homeState extends State<home> {
//   Future<List<User>> users = getUsers();
//   static Future<List<User>> getUsers() async {
//     const url = 'https://verified-mammal-79.hasura.app/api/rest/users/0#users';
//     final response = await http.get(Uri.parse(url));
//     final body = json.decode(response.body);
//     return body.map<User>(User.fromJson).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: FutureBuilder<List<User>>(
//         future: users,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//            } else if (snapshot.hasError) {
//            return Text('${snapshot.error}');
//          }
//           else if (snapshot.hasData) {
//             final users = snapshot.data;
//             return buildUsers(users!);
//           } else {
//             return const Text('No User Data');
//           }
//         },
//       )),
//     );
//   }

//   Widget buildUsers(List<User> users) => ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return Card(
//             child: ListTile(
//               leading: CircleAvatar(
//                 radius: 28,
//                 backgroundImage: NetworkImage('https://images.unsplash.com/photo-1499557354967-2b2d8910bcca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHByb2ZpbGUlMjBnaXJsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
//               ),
//               title: Text(user.first_name),
//               subtitle: Text(user.email),
//             ),
//           );
//         },
//       );
// }

// import 'package:flutter/material.dart';
// import 'dart:async' show Future;
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   @override
//   HomePageState createState() => new HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   List? users;
//   bool loading = false;

//   Future<String> getUsers() async {
//     setState(() => this.loading = true);
//     var response = await http
//         .get(Uri.parse('https://verified-mammal-79.hasura.app/api/rest/users/0#users'));

//     setState(() => users = json.decode(response.body.toString()));

//     setState(() => this.loading = false);
//     return 'success';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     this.getUsers();
//     // getUsers().whenComplete(() {
//     //   setState(() {});
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: new Column(
//         children: <Widget>[
//           this.loading
//               ? new Expanded(
//                   child: new ListView.builder(
//                       itemCount: users == null ? 0 : users!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var name = users![index]['first_name'];
//                         var email = users![index]['email'];

//                         return new Column(
//                           children: <Widget>[
//                             new ListTile(
//                               leading: CircleAvatar(
//                                 child: new Icon(Icons.account_box),
//                               ),
//                               title: Text(name),
//                               subtitle: Text(email),
//                             ),
//                             new Divider(),
//                           ],
//                         );
//                       }),
//                 )
//               : new Center(
//                   child: new CircularProgressIndicator(),
//                   heightFactor: 12.0,
//                 )
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:async' show Future;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// class HomePage extends StatefulWidget {
//   @override
//   HomePageState createState() => new HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   late List users;
//   bool loading = false;

//   Future<String> getUsers() async {
//     setState(() => this.loading = true);
//     final response =
//         await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

//     setState(() => users = json.decode(response.body.toString()));

//     setState(() => this.loading = false);
//     return 'success';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     this.getUsers();
//   }   

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           this.loading
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                   heightFactor: 12.0,
//                 )
//               : Expanded(
//                   child:ListView.builder(
//                       itemCount: users == null ? 0 : users.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var name = users[index]['first_name'];
//                         var email = users[index]['email'];
//                         return Column(
//                           children: <Widget>[
//                             ListTile(
//                               leading: const CircleAvatar(
//                                 child: Icon(Icons.account_box),
//                               ),
//                               title: Text(name),
//                               subtitle: Text(email),
//                             ),
//                             const Divider(),
//                           ],
//                         );
//                       }),
//                 ),
//         ],
//       ),
//     );
//   }
// } 