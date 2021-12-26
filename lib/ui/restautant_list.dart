import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widget/card_restaurant.dart';
import 'package:http/http.dart' as http;

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  Icon customIcon = Icon(Icons.search);

  late TextEditingController _searchQuery;
  String searchQuery = 'Search Query';
  bool _isSearch = false;

  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: _stopSearching),
    );

    setState(() {
      _isSearch = true;
    });
  }

  void _stopSearching() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });

    setState(() {
      _isSearch = false;
    });
  }

  void _getQuery(String query) {
    Navigator.pushNamed(context, SearchPage.routeName, arguments: query);
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  List<Widget> _buildAction() {
    if (_isSearch) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            if (_searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _getQuery(_searchQuery.text);
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: _startSearch,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget customSearchBar =
        Text('Restaurant', style: Theme.of(context).textTheme.headline4);

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
          leading: _isSearch ? const BackButton() : null,
          title: _isSearch ? _buildSearchField() : customSearchBar,
          actions: _buildAction(),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return ChangeNotifierProvider<RestaurantProvider>(
      create: (_) =>
          RestaurantProvider(apiService: ApiService(client: http.Client()))
              .getRestaurants(),
      child: Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            var detail = state.result.restaurants;
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth <= 700) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.result.restaurants.length,
                  itemBuilder: (context, index) {
                    return CardRestaurant(restaurant: detail[index]);
                  },
                );
              } else if (constraints.maxWidth <= 1100) {
                return GridView.count(
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  children: List.generate(detail.length, (index) {
                    return CardRestaurantWeb(restaurant: detail[index]);
                  }),
                );
              } else {
                return GridView.count(
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 6,
                  shrinkWrap: true,
                  children: List.generate(detail.length, (index) {
                    return CardRestaurantWeb(restaurant: detail[index]);
                  }),
                );
              }
            });
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

  Widget _buildSearchField() {
    return TextField(
      cursorColor: Colors.white,
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search ...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }
}
