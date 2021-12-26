import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/model/restaurant_model.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurant();
  }

  late RestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantResult get result => _restaurantResult;
  ResultState get state => _state;

  RestaurantProvider getRestaurants() {
    fetchAllRestaurant();
    return this;
  }

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurants = await apiService.listResto();
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;

        notifyListeners();
        return _restaurantResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      print('No Internet Connection');
      return _message = 'Error: No Internet Connection';
    }
  }
}
