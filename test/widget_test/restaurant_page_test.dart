import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/api/api_controller.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/ui/restaurant_list_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

Widget createRestaurantPage() => ChangeNotifierProvider<RestaurantProvider>(
      create: (context) => RestaurantProvider(
        apiService: ApiService(),
        httpClient: Client(),
      ),
      child: const MaterialApp(
        home: RestaurantListPage(),
      ),
    );

void main() {
  testWidgets('Test List View', (widgetTester) async {
    await widgetTester.pumpWidget(createRestaurantPage());

    expect(find.byType(ListView), findsOneWidget);
  });
}
