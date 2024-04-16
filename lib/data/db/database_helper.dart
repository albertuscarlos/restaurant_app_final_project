import 'package:sqflite/sqflite.dart';

import 'package:flutter_restaurant_app/data/models/restaurant_details.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavouriteRestaurant = 'favourites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavouriteRestaurant(
            id TEXT PRIMARY KEY,
            data TEXT
          )''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  Future<void> insertFavourites(
      RestaurantDetailsData restaurantDetailsData) async {
    final db = await database;
    await db!.insert(_tblFavouriteRestaurant,
        {'data': restaurantDetailsData.toJsonString()});
  }

  Future<List<RestaurantDetailsData>> getFavourites() async {
    final db = await database;
    List<Map<String, dynamic>> result =
        await db!.query(_tblFavouriteRestaurant);

    return result
        .map((e) => RestaurantDetailsData.fromJsonString(e['data']))
        .toList();
  }

  Future<RestaurantDetailsData> getFavouritesById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db!.query(
      _tblFavouriteRestaurant,
      where: "data LIKE ?",
      whereArgs: ['%"id":"$id"%'],
    );

    if (result.isNotEmpty) {
      return RestaurantDetailsData.fromJsonString(result.first['data']);
    } else {
      // Return an empty instance of RestaurantDetailsData if no record is found
      return RestaurantDetailsData(
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
    }
  }

  Future<void> deleteFavourites(String id) async {
    final db = await database;
    await db!.delete(
      _tblFavouriteRestaurant,
      where: 'data LIKE ?',
      whereArgs: ['%"id":"$id"%'],
    );
  }
}
