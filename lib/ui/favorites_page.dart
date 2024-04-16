import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/common/style.dart';
import 'package:flutter_restaurant_app/provider/database_provider.dart';
import 'package:flutter_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/utils/result_state.dart';
import 'package:flutter_restaurant_app/widgets/restaurant_list_container.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Restaurant App',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Favorites Restaurant List',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<DatabaseProvider>(
                        builder: (context, value, _) {
                          if (value.state == ResultState.loading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            );
                          } else {
                            if (value.state == ResultState.hasData) {
                              return Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(10),
                                  itemCount: value.favorites.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: (1 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width <=
                                            370
                                        ? 0.55
                                        : 1.5),
                                  ),
                                  itemBuilder: (context, index) {
                                    final restaurantData =
                                        value.favorites[index];
                                    log('Favorites Data: ${value.favorites.length}');
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RestaurantDetailPage.routeName,
                                          arguments: restaurantData.id,
                                        );
                                      },
                                      child: RestaurantListContainer(
                                        picture: restaurantData.pictureId,
                                        city: restaurantData.city,
                                        rating:
                                            restaurantData.rating.toString(),
                                        name: restaurantData.name,
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (value.state == ResultState.error) {
                              return Center(
                                child: Text(value.message),
                              );
                            } else if (value.state == ResultState.noData) {
                              return Center(
                                child: Text(value.message),
                              );
                            } else {
                              return const Text('');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
