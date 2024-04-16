import 'dart:convert';

import 'package:flutter_restaurant_app/data/models/restaurant.dart';

class RestaurantDetailsResponse {
  final bool error;
  final String message;
  final RestaurantDetailsData? restaurantDetailsData;

  RestaurantDetailsResponse({
    required this.error,
    required this.message,
    required this.restaurantDetailsData,
  });

  factory RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsResponse(
      error: json['error'],
      message: json['message'],
      restaurantDetailsData: RestaurantDetailsData.fromJson(
        json['restaurant'],
      ),
    );
  }
}

class RestaurantDetailsData extends RestaurantData {
  final String address;
  final List<CategoriesData> categories;
  final Menu menu;
  final List<CustomerReviews> customerReviews;

  RestaurantDetailsData({
    required this.address,
    required this.categories,
    required this.menu,
    required this.customerReviews,
    required super.id,
    required super.name,
    required super.description,
    required super.pictureId,
    required super.city,
    required super.rating,
  });

  factory RestaurantDetailsData.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsData(
      address: json['address'],
      categories: List.from((json['categories'] as List<dynamic>)
          .map((e) => CategoriesData.fromModel(e))),
      menu: Menu.fromJson(json['menus']),
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((e) => CustomerReviews.fromModel(e))
          .toList(),
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
        "address": address,
        "categories": categories.map((e) => e.toJson()).toList(),
        "menus": menu.toJson(),
        "customerReviews": customerReviews.map((e) => e.toJson()).toList(),
      };

  String toJsonString() => json.encode(toJson());

  factory RestaurantDetailsData.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return RestaurantDetailsData.fromJson(jsonData);
  }
}

class CategoriesData {
  final String name;

  CategoriesData({
    required this.name,
  });

  factory CategoriesData.fromModel(Map<String, dynamic> json) => CategoriesData(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Menu {
  List<MenuData>? foods;
  List<MenuData>? drinks;
  Menu({
    required this.foods,
    required this.drinks,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods: json['foods'] != null
          ? List.from(
              (json['foods'] as List<dynamic>).map(
                (e) => MenuData.fromModel(e),
              ),
            )
          : null,
      drinks: json['drinks'] != null
          ? List.from(
              (json['drinks'] as List<dynamic>).map(
                (e) => MenuData.fromModel(e),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "foods": foods!.map((e) => e.toJson()).toList(),
        "drinks": drinks!.map((e) => e.toJson()).toList(),
      };
}

class MenuData {
  final String name;

  MenuData({required this.name});

  factory MenuData.fromModel(Map<String, dynamic> json) => MenuData(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReviews {
  final String name;
  final String review;
  final String date;

  CustomerReviews({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReviews.fromModel(Map<String, dynamic> json) =>
      CustomerReviews(
        name: json['name'],
        review: json['review'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}
