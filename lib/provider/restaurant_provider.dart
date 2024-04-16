import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/api/api_controller.dart';
import 'package:flutter_restaurant_app/data/models/restaurant.dart';
import 'package:flutter_restaurant_app/data/models/restaurant_details.dart';
import 'package:flutter_restaurant_app/utils/result_state.dart';
import 'package:http/http.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final Client httpClient;

  RestaurantProvider({required this.apiService, required this.httpClient}) {
    getRestaurantData();
  }

  List<RestaurantData> _restaurantResponse = [];
  List<RestaurantData> _searchRestaurant = [];
  late ResultState _state;
  String _message = '';
  String searchText = '';

  List<RestaurantData> get restaurantResponse => _restaurantResponse;
  List<RestaurantData> get searchRestaurant => _searchRestaurant;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> getRestaurantData() async {
    log('TopSearch: $searchText');
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.getAllRestaurant(httpClient);
      if (result.restaurants!.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data not found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantResponse = result.restaurants!;
        return updateData();
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      log('Get Restaurant Data Catch: $e');
      return _message = 'No Internet Connection';
    }
  }

  updateData() {
    _searchRestaurant.clear();
    if (searchText.isEmpty) {
      log('Search Text Empty: $searchText');
      _searchRestaurant.addAll(_restaurantResponse);
    } else {
      log('Search Text Avail: $searchText');
      final searchRestaurantName = _restaurantResponse
          .where((element) => element.name.toLowerCase().contains(searchText))
          .toList();
      if (searchRestaurantName.isEmpty) {
        _state = ResultState.noData;
        _searchRestaurant.addAll(searchRestaurantName);
      } else {
        _state = ResultState.hasData;
        _searchRestaurant.addAll(searchRestaurantName);
      }
    }
    notifyListeners();
  }

  search(String restaurantName) {
    searchText = restaurantName;
    updateData();
  }
}

class RestaurantDetailsProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  final Client httpClient;

  RestaurantDetailsProvider({
    required this.apiService,
    required this.id,
    required this.httpClient,
  }) {
    getRestaurantDetails();
  }

  RestaurantDetailsData? _restaurantDetailsData;
  late ResultState _state;
  String _message = '';

  RestaurantDetailsData? get restaurantDetailsData => _restaurantDetailsData;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> getRestaurantDetails() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.getRestaurantDetails(id, httpClient);
      if (result.restaurantDetailsData == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data Not Found!';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetailsData = result.restaurantDetailsData!;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      log('Get Restaurant Details Data Catch: $e');
      return _message = 'No Internet Connection';
    }
  }
}
