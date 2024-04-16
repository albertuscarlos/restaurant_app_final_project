import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/db/database_helper.dart';
import 'package:flutter_restaurant_app/data/models/restaurant_details.dart';
import 'package:flutter_restaurant_app/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantDetailsData> _favorites = [];

  List<RestaurantDetailsData> get favorites => _favorites;

  Future<dynamic> _getFavorites() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _favorites = await databaseHelper.getFavourites();

      if (_favorites.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = "You Don't Have Favorite Restaurant Yet";
      }
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      log('Get Restaurant Data Catch: $e');
      return _message = 'No Internet Connection';
    }
  }

  void addFavorites(RestaurantDetailsData restaurantDetailsData) async {
    try {
      await databaseHelper.insertFavourites(restaurantDetailsData);
      log('Added');
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';

      notifyListeners();
    }
  }

  Future<bool> isAddedToFavorite(String id) async {
    final favorites = await databaseHelper.getFavouritesById(id);
    return favorites.id.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.deleteFavourites(id);
      log('DELETED');
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}

class RestaurantFavoriteDetails extends DatabaseProvider {
  final String id;
  RestaurantDetailsData _favoritesById = RestaurantDetailsData(
    id: '',
    name: '',
    description: '',
    pictureId: '',
    city: '',
    rating: 0,
    address: '',
    categories: [],
    menu: Menu(foods: [], drinks: []),
    customerReviews: [],
  );
  RestaurantDetailsData get favoritesById => _favoritesById;
  RestaurantFavoriteDetails({
    required super.databaseHelper,
    required this.id,
  }) {
    getFavoritesById();
  }

  void getFavoritesById() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _favoritesById = await databaseHelper.getFavouritesById(id);
      if (_favoritesById.id.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
      } else if (_favoritesById.id.isEmpty) {
        _state = ResultState.noData;
        _message = "You Don't Have Favorite Restaurant Yet";
        notifyListeners();
      } else {
        _state = ResultState.error;
        _message = "Error when fetching data";
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }

    notifyListeners();
  }
}
