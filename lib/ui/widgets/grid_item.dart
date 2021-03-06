import 'package:cached_network_image/cached_network_image.dart';
import 'package:cick_movie_app/const.dart';
import 'package:cick_movie_app/data/models/movie_popular.dart';
import 'package:cick_movie_app/data/models/popular.dart';
import 'package:cick_movie_app/ui/screens/movie_detail_screen.dart';
import 'package:cick_movie_app/ui/screens/tv_show_detail_screen.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GridItem extends StatelessWidget {
  final Popular item;

  const GridItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return item is MoviePopular
                    ? MovieDetailScreen(movieId: item.id)
                    : TvShowDetailScreen(tvShowId: item.id);
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: '${Const.imgUrl300}/${item.posterPath}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 240,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 200),
                    placeholder: (context, url) {
                      return Center(
                        child: SpinKitThreeBounce(
                          size: 20,
                          color: secondaryColor,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Icon(
                          Icons.motion_photos_off_outlined,
                          color: secondaryTextColor,
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(4),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 18,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.voteAverage}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryTextColor.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleTextStyle,
            ),
            Text(
              item.releaseDateParse,
              style: subTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
