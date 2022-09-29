// import 'dart:ffi';

// class User {
//   // int id;
//   final String email;
//   final String first_name;
//   final String last_name;
//   final String created_at;
//   final String updated_at;

//   User({
//     //required this.id,
//     required this.email,
//     required this.first_name,
//     required this.last_name,
//     required this.created_at,
//     required this.updated_at,
//   });

//   static User fromJson(json) => User(
//         created_at: json['cr  eated_at'],
//         email: json['email'],
//         first_name:json['first_name'],
//         last_name:json['last_name'],
//         updated_at:json ['updated_at'],
//       );
//   // Map<String, dynamic> toJson() => {
//   //       //'id': id,
//   //       'email': email,
//   //       'first_name': first_name,
//   //       'last_name': last_name,
//   //       'created_at': created_at,
//   //       'updated_at': updated_at,
//   //     };
//   // User.fromJson(Map<String, dynamic> json)
//   //     : first_name = json['first_name'],
//   //       last_name = json['last_name'],
//   //      // id = json['id'],
//   //       email = json['email'],
//   //       created_at = json['created_at'],
//   //       updated_at = json['updated_at'];
// }

// // String getFromList(Array<String, dynamic> json, String key) {
// //   return json != null ? json[key] : "";
// // }


import 'dart:convert';
Users userFromJson(String str) => Users.fromJson(json.decode(str));

String userToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.users,
  });

  List<UserElement>? users;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        users: json["users"] == null
            ? null
            : List<UserElement>.from(
                json["users"].map((x) => UserElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? null
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class UserElement {
  UserElement(
      {
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.bio,
        this.isFavourite
      });

  DateTime? createdAt;
  String? email;
  String? firstName;
  String? id;
  String? lastName;
  DateTime? updatedAt;
  String? bio;
  bool? isFavourite;

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        email: json["email"],
        firstName: json["first_name"],
        id: json["id"],
        lastName: json["last_name"],
        bio: json["bio"],
        isFavourite: json["isFavourite"] == 0 || json["isFavourite"] == null
            ? false
            : true,
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "email": email,
        "first_name": firstName,
        "id": id,
        "last_name": lastName,
        "bio": bio,
        "updated_at": updatedAt?.toIso8601String(),
        "isFavourite": isFavourite,
      };

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "email": email,
      "first_name": firstName,
      "id": id,
      "last_name": lastName,
      "bio": bio,
      "isFavourite": isFavourite == true ? 1 : 0,
    };
    return map;
  }
}
