import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/api/api_controller.dart';
import 'package:flutter_restaurant_app/data/db/database_helper.dart';
import 'package:flutter_restaurant_app/provider/bottom_nav_provider.dart';
import 'package:flutter_restaurant_app/provider/database_provider.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/utils/result_state.dart';
import 'package:flutter_restaurant_app/widgets/restaurant_details_container.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = 'detail_page';
  const RestaurantDetailPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantDetailsProvider>(
          create: (context) => RestaurantDetailsProvider(
              apiService: ApiService(), id: id, httpClient: Client()),
        ),
        ChangeNotifierProvider<RestaurantFavoriteDetails>(
          create: (context) => RestaurantFavoriteDetails(
            databaseHelper: DatabaseHelper(),
            id: id,
          ),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 10),
                child: const Text(
                  'Restaurant App',
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<BottomNavProvider>(
                      builder: (context, navProvider, child) {
                        if (navProvider.bottomNavIndex == 0) {
                          log('RestaurantDetailsFromAPI');
                          return Consumer<RestaurantDetailsProvider>(
                            builder: (context, value, _) {
                              final data = value.restaurantDetailsData;
                              if (value.state == ResultState.loading) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          3),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              } else {
                                if (value.state == ResultState.hasData) {
                                  return Center(
                                      child: RestaurantDetailsContainer(
                                          data: data!));
                                } else if (value.state == ResultState.noData) {
                                  return Center(
                                    child: Text(value.message),
                                  );
                                } else if (value.state == ResultState.error) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    child: Center(
                                      child: Text(value.message),
                                    ),
                                  );
                                } else {
                                  return const Text('Error');
                                }
                              }
                            },
                          );
                        } else {
                          log('FavDetailsFromSqlite');
                          return Consumer<RestaurantFavoriteDetails>(
                            builder: (context, value, _) {
                              final data = value.favoritesById;
                              if (value.state == ResultState.loading) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          3),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              } else {
                                if (value.state == ResultState.hasData) {
                                  return Center(
                                      child: RestaurantDetailsContainer(
                                    data: data,
                                  ));
                                } else if (value.state == ResultState.noData) {
                                  return Center(
                                    child: Text(value.message),
                                  );
                                } else if (value.state == ResultState.error) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    child: Center(
                                      child: Text(value.message),
                                    ),
                                  );
                                } else {
                                  return const Text('Error');
                                }
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
