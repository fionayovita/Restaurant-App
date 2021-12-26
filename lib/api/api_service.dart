import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/model/detail_model.dart';
import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:restaurant_app/model/search_model.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static final String _list = 'list';
  static final String _search = 'search?q=';
  static final String _detail = 'detail/';

  Future<RestaurantResult> listResto() async {
    final response = await http.get(Uri.parse(_baseUrl + _list));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<DetailResult> getDetail(String id) async {
    final response = await client.get(Uri.parse(_baseUrl + _detail + id));
    if (response.statusCode == 200) {
      return DetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<SearchResult> search(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + _search + query));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
