import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widget/card_restaurant.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatelessWidget {
  static const routeName = '/search_list';
  final String query;
  SearchPage({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(18),
              bottomEnd: Radius.circular(18),
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: secondaryColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: Text('Search', style: Theme.of(context).textTheme.headline4),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(
              apiService: ApiService(client: http.Client()), query: query)
          .getSearch(query),
      child: Consumer<SearchProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return ListView.builder(
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: state.result.restaurants.length,
              itemBuilder: (context, index) {
                var detail = state.result.restaurants[index];
                return CardRestaurantSearch(
                  restaurant: detail,
                );
              },
            );
          } else if (state.state == ResultState.NoData) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          } else if (state.state == ResultState.Error) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          } else {
            return Center(
              child: Text(
                'No Connection, failed to load',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          }
        },
      ),
    );
  }
}
