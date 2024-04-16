import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/common/style.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/utils/result_state.dart';
import 'package:flutter_restaurant_app/widgets/restaurant_list_container.dart';
import 'package:flutter_restaurant_app/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

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
          body: RefreshIndicator(
            color: Colors.blue,
            onRefresh: () {
              final provider =
                  Provider.of<RestaurantProvider>(context, listen: false)
                      .getRestaurantData();
              return provider;
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 15, right: 15),
              children: [
                const SizedBox(
                  height: 30,
                ),
                MySearchBar(
                  onChanged: (value) {
                    final provider =
                        Provider.of<RestaurantProvider>(context, listen: false);
                    provider.search(value);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Restaurant List',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
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
                              Consumer<RestaurantProvider>(
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
                                          itemCount:
                                              value.searchRestaurant.length,
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
                                                value.searchRestaurant[index];
                                            log('Filter Data: ${value.searchRestaurant.length}');
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RestaurantDetailPage
                                                      .routeName,
                                                  arguments: restaurantData.id,
                                                );
                                              },
                                              child: RestaurantListContainer(
                                                picture:
                                                    restaurantData.pictureId,
                                                city: restaurantData.city,
                                                rating: restaurantData.rating
                                                    .toString(),
                                                name: restaurantData.name,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else if (value.state ==
                                        ResultState.error) {
                                      return Center(
                                        child: Text(value.message),
                                      );
                                    } else if (value.state ==
                                        ResultState.noData) {
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
              ],
            ),
          )),
    );
  }
}
