import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/common/constants.dart';
import 'package:flutter_restaurant_app/common/style.dart';
import 'package:flutter_restaurant_app/data/models/restaurant_details.dart';
import 'package:flutter_restaurant_app/provider/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class RestaurantDetailsContainer extends StatelessWidget {
  const RestaurantDetailsContainer({super.key, required this.data});

  final RestaurantDetailsData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: data.pictureId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: '${Constants.imgLarge}/${data.pictureId}',
                  placeholder: (context, url) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        Text(
                          'Failed Loading Image',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                    child: Consumer<DatabaseProvider>(
                      builder: (context, dbProvider, child) {
                        return FutureBuilder(
                          future: dbProvider.isAddedToFavorite(data.id),
                          builder: (context, snapshot) {
                            var isFavorite = snapshot.data ?? false;
                            return IconButton(
                              onPressed: () {
                                if (isFavorite) {
                                  dbProvider.removeFavorite(data.id);
                                  Get.snackbar(
                                    'Removed',
                                    'Removed From Favorites',
                                  );
                                } else {
                                  dbProvider.addFavorites(data);
                                  Get.snackbar(
                                    'Added',
                                    'Added to Favorites',
                                  );
                                }
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.red
                                    : Colors.grey.shade400,
                                size: 30,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        '${data.rating}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              SizedBox(
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category =
                              data.categories.map((e) => e.name).toList();
                          return Text(
                            category[index],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 5,
                                height: 5,
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                                height: 5,
                              ),
                            ],
                          );
                        },
                        itemCount: data.categories.length,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  Text(
                    '${data.city}, ',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data.address,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.description,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Foods',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 120,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    mainAxisExtent: 100),
                            itemBuilder: (context, index) {
                              log('${data.menu.foods!.length}');
                              final foodsData =
                                  data.menu.foods!.map((e) => e.name).toList();
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.shade200,
                                ),
                                child: Center(
                                  child: Text(
                                    foodsData[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: data.menu.foods!.length,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Drinks',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 120,
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 30,
                                        mainAxisExtent: 100),
                                itemBuilder: (context, index) {
                                  log('${data.menu.drinks!.length}');
                                  final drinksData = data.menu.drinks!
                                      .map((e) => e.name)
                                      .toList();
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        drinksData[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: data.menu.drinks!.length,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 50,
                          crossAxisCount: 1,
                        ),
                        itemBuilder: (context, index) {
                          final reviews = data.customerReviews[index];
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/img/photo_2.jpg',
                                  scale: 2,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                reviews.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Text(
                                  reviews.review,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                reviews.date,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          );
                        },
                        itemCount: data.customerReviews.length,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ],
    );
  }
}
