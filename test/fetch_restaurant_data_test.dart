import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant_app/data/api/api_controller.dart';
import 'package:flutter_restaurant_app/data/models/restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'fetch_restaurant_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('Fetch Restaurant Data Test', () async {
    const String baseUrl = 'https://restaurant-api.dicoding.dev';
    final data = await rootBundle.loadString('assets/restaurant_data.json');
    final client = MockClient();

    when(client.get(Uri.parse('$baseUrl/list'))).thenAnswer((_) async {
      return http.Response(
        data,
        200,
      );
    });

    final service = await ApiService().getAllRestaurant(client);
    expect(service, isA<RestaurantResponse>());
  });
}
