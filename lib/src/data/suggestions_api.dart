import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class SuggestionDatabase {
  //verify Phone number
  Future<List<dynamic>> loadSuggestions(String? uuid) async {
    final response = await http.post(
      Uri.parse(
        'https://cbir.osemeke.com/hybrid_classification/$uuid',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = json.decode(response.body);
    //log(data.toString());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> sourceList = data['classifications'];
      return sourceList;
    } else {
      throw Exception("error suggesting related products");
    }
  }

  //search for product
  Future<int> searchMarketplaceProducts(String? uuid, String? word) async {
    final response = await http.post(
      Uri.parse(
        'https://cbir.osemeke.com/search_product/$uuid',
      ),
      body: jsonEncode({"keyword": word, "pages": 5}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = json.decode(response.body);
    //log(data.toString());

    if (response.statusCode == 200) {
      return response.statusCode;
    } else if (response.statusCode != 200) {
      return response.statusCode;
    } else {
      throw Exception("error suggesting related products");
    }
  }

  //reteival for product
  Future<List<dynamic>> getRetrivalProducts(String? uuid) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://cbir.osemeke.com/retrieve_similar_images/$uuid',
        ),
        body: jsonEncode({"algo": "euclidean"}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      log(data.toString());

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception("error suggesting related products");
      }
    } catch (e) {
      throw Exception(
        "We couldn't fetch image product or anything relating to it",
      );
    }
  }
}
