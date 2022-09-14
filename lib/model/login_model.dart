// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

List<Login> loginFromJson(String str) =>  List<Login>.from(json.decode(str).map((x) => Login.fromJson(x)));

String loginToJson(List<Login> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Login {
  Login({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.userId,
    this.empId,
    this.firstName,
    this.lastName,
    this.tokenId,
  });

  String? userId;
  String? empId;
  String? firstName;
  String? lastName;
  String? tokenId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"] == null ? null : json["userId"],
        empId: json["empId"] == null ? null : json["empId"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        tokenId: json["tokenId"] == null ? null : json["tokenId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId == null ? null : userId,
        "empId": empId == null ? null : empId,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "tokenId": tokenId == null ? null : tokenId,
      };
}
