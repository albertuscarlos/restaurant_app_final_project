import 'dart:convert';

import 'package:flutter_restaurant_app/data/models/restaurant.dart';
import 'package:flutter_restaurant_app/data/models/restaurant_details.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantResponse> getAllRestaurant(http.Client client) async {
    final request = await client.get(Uri.parse('$_baseUrl/list'));
    if (request.statusCode == 200) {
      return RestaurantResponse.fromJson(jsonDecode(request.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<RestaurantDetailsResponse> getRestaurantDetails(
      String id, http.Client client) async {
    final request = await client.get(Uri.parse('$_baseUrl/detail/$id'));
    if (request.statusCode == 200) {
      return RestaurantDetailsResponse.fromJson(jsonDecode(request.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
