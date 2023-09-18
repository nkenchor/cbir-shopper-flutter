import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ImageUploadFunction {
  //instance of Dio()
  final dio = Dio();

  Future<dynamic> paymentImage({
    File? image,
  }) async {
    var formData = FormData.fromMap(
      {
        "image": await MultipartFile.fromFile(
          image!.path,
        )
      },
    );

    try {
      var response = await dio.post(
        "https://cbir.osemeke.com//upload_image",
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: formData,
      );
      debugPrint('res==================${response.toString()}');

      print("))))))))))))(((((((((((((((((${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.data;
      }
    } on SocketException {
    } catch (e) {
      debugPrint("error response=============> $e");
    }
  }
}
