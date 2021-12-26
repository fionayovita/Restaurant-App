import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/model/detail_model.dart';
import 'package:restaurant_app/utils/result_state.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailProvider({required this.apiService, required String id}) {
    fetchDetail(id);
  }

  late DetailResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  DetailResult get result => _restaurantResult;
  ResultState get state => _state;

  DetailProvider getRestaurants(String id) {
    fetchDetail(id);
    return this;
  }

  Future<dynamic> fetchDetail(id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getDetail(id);
      if (restaurant.restaurant.id.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        _restaurantResult = restaurant;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error: No Internet Connection';
    }
  }
}
