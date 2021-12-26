import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/model/detail_model.dart';

class CardReview extends StatelessWidget {
  final CustomerReviews reviews;

  const CardReview({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviews.review,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 15,
                      color: Colors.indigo,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      reviews.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.today,
                      size: 15,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      reviews.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
