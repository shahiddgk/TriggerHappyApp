// ignore_for_file: avoid_print, prefer_collection_literals, prefer_typing_uninitialized_variables, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_exceptions.dart';

// ignore: non_constant_identifier_names
String MESSAGE_KEY = 'message';

class ResponseHandler {
  Map<String, String> setTokenHeader() {
    return {
      '': ''
    }; //{'Authorization': 'Bearer ${Constants.authenticatedToken}'};
  }

  Future post(
      Uri url, Map<String, dynamic> params,) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http.post(url, body: params, headers: head).timeout(const Duration(seconds: 45));
      print('Response =====> ${response.body}');
      responseJson = json.decode(response.body.toString());
      // ignore: avoid_print
      print(responseJson);
      if(responseJson['status']!= 200) throw FetchDataException(responseJson['message'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future postWithOutParams(
      Uri url,) async {
    var head = <String, String>{};
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http.post(url, headers: head).timeout(const Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      // ignore: avoid_print
      print(responseJson);
      if(responseJson['status']!= 200) throw FetchDataException(responseJson['message'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future postImage(Uri url, Map<String, String> params,
      File image) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/x-www-form-urlencoded';
    var res;
    try {
      final request = http.MultipartRequest('POST', url);
      final file = await http.MultipartFile.fromPath(
          'profile_img',
          image
              .path); //,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
      request.files.add(file);
          request.fields.addAll(params);
      await request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
        print(response.stream);
        res = response;
      });
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future stripePost(
      Uri url, dynamic body,String publishableKey) async {
    var head = <String, String>{};

    head['Authorization'] = 'Bearer $publishableKey';
    head['content-type'] = 'application/x-www-form-urlencoded';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http.post(url, body: body, headers: head).timeout(const Duration(seconds: 45));
      responseJson = response.body;
      // ignore: avoid_print
      print(responseJson);
      if(response.statusCode!= 200) throw FetchDataException(responseJson);
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Future postImage(String url, Map<String, String> params,
  //     File image, bool isHeaderRequired, String message) async {
  //   var head = Map<String, String>();
  //   head['content-type'] = 'application/x-www-form-urlencoded';
  //   var res;
  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(url));
  //     if (image != null) {
  //       final file = await http.MultipartFile.fromPath(
  //           'image',
  //           image
  //               .path); //,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
  //       request.files.add(file);
  //     }
  //     request.fields.addAll(params);
  //     await request.send().then((response) {
  //       if (response.statusCode == 200) print("Uploaded!");
  //       res = GeneralResponseModel(
  //           status: response.statusCode == 200,
  //           message: response.statusCode == 200
  //               ? "User $message"
  //               : "User Not $message",
  //           data: null);
  //     });
  //     return res;
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  // }

  Future get(Uri url, bool isHeaderRequired) async {
    var head = <String, String>{};
    head['content-type'] = 'application/json; charset=utf-8';
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http.get(url, headers: head).timeout(const Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      // ignore: avoid_print
      print(responseJson);
      if(responseJson['status']!= 200) throw FetchDataException(responseJson['message'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

}
