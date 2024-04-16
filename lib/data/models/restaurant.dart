class RestaurantResponse {
  final bool error;
  final String message;
  final int count;
  final List<RestaurantData>? restaurants;

  RestaurantResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
        error: json['error'],
        message: json['message'],
        count: json['count'],
        restaurants: json['restaurants'] != null
            ? (json['restaurants'] as List<dynamic>)
                .map((e) => RestaurantData.fromModel(e))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List.from(restaurants!.map((e) => e.toJson()))
      };
}

class RestaurantData {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final num rating;

  RestaurantData({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantData.fromModel(Map<String, dynamic> json) {
    return RestaurantData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
