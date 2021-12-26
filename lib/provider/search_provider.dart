import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/model/search_model.dart';
import 'package:restaurant_app/utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService, required String query}) {
    _fetchAllSearch(query);
  }

  late SearchResult _searchResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  SearchResult get result => _searchResult;
  ResultState get state => _state;

  SearchProvider getSearch(String query) {
    _fetchAllSearch(query);
    return this;
  }

  Future<dynamic> _fetchAllSearch(String query) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurants = await apiService.search(query);
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Restaurant not found';
      } else {
        _state = ResultState.HasData;
        _searchResult = restaurants;
        notifyListeners();
        return _searchResult = restaurants;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error: No Internet Connection';
    }
  }
}
