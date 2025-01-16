import 'dart:convert';
import 'dart:developer';

import 'package:eshop/settings.dart';
import 'package:eshop/ui/styles/DesignConfig.dart';
import 'package:eshop/utils/Hive/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/brands_model.dart';

class GetBrandsProvider extends ChangeNotifier {
  bool isLoading = false;

  BrandModel? _brandModel;
  BrandModel? get brandModel => _brandModel;

  Future<void> getBrandId({required String brandId}) async {
    const String apiUrl = '${AppSettings.baseUrl}get_brands_data';

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(
          {"brand_id": brandId},
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        _brandModel = BrandModel.fromJson(jsonResponse);
        log(response.body);
      }
    } catch (e) {
      log('An error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;

  LoginModel? _loginModel;
  LoginModel? get loginModel => _loginModel;

  Future<void> login(BuildContext context, {required String mobile}) async {
    const String apiUrl = '${AppSettings.baseUrl}get_brands_data';

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({"mobile": mobile}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        _loginModel = LoginModel.fromJson(jsonResponse);
        HiveUtils.setJWT(_loginModel!.token!);

        setSnackbar(_loginModel!.message!, context);

        final data = _loginModel?.data?.first;
        if (data != null) {
          id = data.id;
          username = data.username;
          mobile = data.mobile.toString();
          image = data.image;
        }

        log(response.body);
      } else {
        setSnackbar("Failed to login", context);
      }
    } catch (e) {
      log('An error occurred: $e');
      setSnackbar("An error occurred", context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

////////
///
String? password,
    mobile,
    username,
    email,
    id,
    mobileno,
    city,
    area,
    pincode,
    address,
    latitude,
    longitude,
    image,
    loginType;

class LoginModel {
  bool? error;
  String? message;
  String? token;
  List<Data>? data;

  LoginModel({this.error, this.message, this.token, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    token = json['token'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? mobile;
  String? apikey;
  String? username;
  String? balance;
  String? image;
  String? createdAt;

  Data(
      {this.id,
        this.mobile,
        this.apikey,
        this.username,
        this.balance,
        this.image,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    apikey = json['apikey'];
    username = json['username'];
    balance = json['balance'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mobile'] = mobile;
    data['apikey'] = apikey;
    data['username'] = username;
    data['balance'] = balance;
    data['image'] = image;
    data['created_at'] = createdAt;
    return data;
  }
}
