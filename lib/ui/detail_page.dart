import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/detail_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widget/card_review.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String id;
  const RestaurantDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/local_restaurant.json'),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth <= 700) {
                        return content(context);
                      } else {
                        return contentWeb(context);
                      }
                    },
                  );
                } else {
                  return Center(child: Text('Could not load data'));
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return ChangeNotifierProvider<DetailProvider>(
      create: (_) =>
          DetailProvider(apiService: ApiService(client: http.Client()), id: id)
              .getRestaurants(id),
      child: Consumer<DetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return Stack(
              children: [
                Container(
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                          'https://restaurant-api.dicoding.dev/images/medium/' +
                              state.result.restaurant.pictureId),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundColor: secondaryColor,
                          child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(top: 250),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _contentResto(context),
                      _contentDesc(context),
                      _contentMenu(context),
                      _contentReview(context),
                    ],
                  ),
                )
              ],
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
            print('failed to load image');
            return Center(child: Text('No Connection, failed to load'));
          }
        },
      ),
    );
  }

  Widget contentWeb(BuildContext context) {
    return ChangeNotifierProvider<DetailProvider>(
      create: (_) =>
          DetailProvider(apiService: ApiService(client: http.Client()), id: id)
              .getRestaurants(id),
      child: Consumer<DetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 60.0),
                  color: backgroundColor,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/medium/' +
                                  state.result.restaurant.pictureId,
                              fit: BoxFit.cover),
                        ),
                        _contentResto(context),
                        _contentDesc(context),
                        _contentMenuWeb(context),
                        _contentReview(context)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 70.0, top: 30),
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ],
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
            print('failed to load data');
            return Center(
              child: Text('No Connection, failed to load'),
            );
          }
        },
      ),
    );
  }

  Widget _contentResto(BuildContext context) {
    String bullet = "\u2022 ";

    return ChangeNotifierProvider<DetailProvider>(
      create: (_) =>
          DetailProvider(apiService: ApiService(client: http.Client()), id: id)
              .getRestaurants(id),
      child: Consumer<DetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            var detail = state.result.restaurant;
            return Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(detail.name,
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            '${detail.rating}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: Colors.indigo),
                          SizedBox(width: 8),
                          Text(
                            '${detail.city}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Category',
                            style: Theme.of(context).textTheme.headline6),
                        SizedBox(height: 5),
                        ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: state.result.restaurant.categories.map(
                            (drink) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  bullet + drink.name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (state.state == ResultState.NoData) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          } else if (state.state == ResultState.Error) {
            print('failed to load data');
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          } else {
            print('failed to load data');
            return Center(child: Text('No Connection, failed to load'));
          }
        },
      ),
    );
  }

  Widget _contentDesc(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'About',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 10),
          ChangeNotifierProvider<DetailProvider>(
            create: (_) => DetailProvider(
                    apiService: ApiService(client: http.Client()), id: id)
                .getRestaurants(id),
            child: Consumer<DetailProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.state == ResultState.HasData) {
                  return Text(state.result.restaurant.description,
                      style: Theme.of(context).textTheme.bodyText1);
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
                  print('failed to load image');
                  return Center(child: Text('No Connection, failed to load'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentMenu(BuildContext context) {
    String bullet = "\u2022 ";

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Menu', style: Theme.of(context).textTheme.headline5),
          SizedBox(height: 15),
          Container(
            child: ChangeNotifierProvider<DetailProvider>(
              create: (_) => DetailProvider(
                      apiService: ApiService(client: http.Client()), id: id)
                  .getRestaurants(id),
              child: Consumer<DetailProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.state == ResultState.HasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 80,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'Foods',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                              state.result.restaurant.menus.foods.map((foods) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                bullet + foods.name,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 80,
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            'Drinks',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children:
                              state.result.restaurant.menus.drinks.map((drink) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                bullet + drink.name,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  } else if (state.state == ResultState.NoData) {
                    return Center(child: Text(state.message));
                  } else if (state.state == ResultState.Error) {
                    print('failed to load data');
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  } else {
                    print('failed to load data');
                    return Center(
                      child: Text(
                        'No Connection, failed to load',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _contentMenuWeb(BuildContext context) {
    String bullet = "\u2022 ";

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Menu', style: Theme.of(context).textTheme.headline5),
          SizedBox(height: 15),
          ChangeNotifierProvider<DetailProvider>(
            create: (_) => DetailProvider(
                    apiService: ApiService(client: http.Client()), id: id)
                .getRestaurants(id),
            child: Consumer<DetailProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.state == ResultState.HasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 80,
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                'Foods',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            ListView(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: state.result.restaurant.menus.foods
                                  .map((foods) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    bullet + foods.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 80,
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                'Drinks',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            ListView(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: state.result.restaurant.menus.drinks
                                  .map((drink) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    bullet + drink.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (state.state == ResultState.NoData) {
                  return Center(
                      child: Text(
                    state.message,
                  ));
                } else if (state.state == ResultState.Error) {
                  print('failed to load data');
                  return Center(
                    child: Text(
                      state.message,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                } else {
                  print('failed to load data');
                  return Center(
                    child: Text(
                      'No Connection, failed to load',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentReview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(
                apiService: ApiService(client: http.Client()), id: id)
            .getRestaurants(id),
        child: Consumer<DetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.HasData) {
              return Column(
                children: <Widget>[
                  Text('Reviews', style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 15),
                  ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.result.restaurant.customerReviews.length,
                      itemBuilder: (context, index) {
                        var review =
                            state.result.restaurant.customerReviews[index];
                        return CardReview(reviews: review);
                      })
                ],
              );
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.Error) {
              print('failed to load data');
              return Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            } else {
              print('failed to load data');
              return Center(
                child: Text(
                  'No Connection, failed to load',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
