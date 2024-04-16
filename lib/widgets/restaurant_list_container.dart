import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/common/constants.dart';
import 'package:flutter_restaurant_app/common/style.dart';

class RestaurantListContainer extends StatelessWidget {
  final String picture;
  final String city;
  final String rating;
  final String name;
  const RestaurantListContainer({
    super.key,
    required this.picture,
    required this.city,
    required this.rating,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: picture,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: '${Constants.imgSmall}$picture',
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              Expanded(
                child: Text(
                  city,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Text(
                rating,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
