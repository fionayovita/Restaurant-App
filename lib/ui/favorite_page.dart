import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widget/card_restaurant.dart';

class FavoritePage extends StatelessWidget {
  static const String favTitle = 'Favorites';

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.HasData) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.favorites[index]);
            },
          );
        } else {
          return Center(
            child: Text('You have no favorite restaurants',
                style: Theme.of(context).textTheme.subtitle1),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Favorites', style: Theme.of(context).textTheme.headline4),
          toolbarHeight: 80,
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(18),
              bottomEnd: Radius.circular(18),
            ),
          ),
        ),
        body: _buildList());
  }
}
