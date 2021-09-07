import 'package:cick_movie_app/models/TvShow.dart';
import 'package:cick_movie_app/pages/grid_view_items.dart';
import 'package:cick_movie_app/ui/tv_show_detail_screen.dart';
import 'package:flutter/material.dart';

class TvShowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridViewItems(items: tvShows, routeScreen: TvShowDetailScreen());
  }
}
