import 'dart:io';

import 'package:dio/dio.dart' as dio;
class SignUpBody {
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? refCode;
  String? exist_category;
  String? store_name;
  String? store_address;
  String? new_category;
  String? images;
  File? file;

  SignUpBody({this.fName, this.lName, this.phone, this.email='', this.password, this.refCode = '', this.exist_category,
  this.store_name, this.store_address, this.new_category, this.images, this.file});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    refCode = json['ref_code'];
    exist_category = json['exist_category'];
    store_name = json['store_name'];
    store_address = json['store_address'];
    new_category = json['new_category'];
    images = dio.MultipartFile.fromFile(json['images[]']).toString();
    file =  json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['ref_code'] = refCode;
    data['exist_category'] = exist_category;
    data['store_name'] = store_name;
    data['store_address'] = store_address;
    data['new_category'] = new_category;
    data['images[]'] = images;
    data[images!] = file;
    return data;
  }
}
