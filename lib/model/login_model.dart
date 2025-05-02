// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

List<Login> loginFromJson(String str) =>
    List<Login>.from(json.decode(str).map((x) => Login.fromJson(x)));

String loginToJson(List<Login> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Login {
  Login({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
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
        userId: json["userId"],
        empId: json["empId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        tokenId: json["tokenId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "empId": empId,
        "firstName": firstName,
        "lastName": lastName,
        "tokenId": tokenId,
      };
}
