import 'package:cick_movie_app/data/db/favorite_database.dart';
import 'package:cick_movie_app/ui/pages/favorite_page.dart';
import 'package:cick_movie_app/ui/pages/movie_page.dart';
import 'package:cick_movie_app/ui/pages/tv_show_page.dart';
import 'package:cick_movie_app/ui/styles/color_scheme.dart';
import 'package:cick_movie_app/ui/styles/text_style.dart';
import 'package:cick_movie_app/ui/widgets/default_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/favorite_app_bar.dart';
import 'package:cick_movie_app/ui/widgets/scroll_to_hide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // initialize final atribute
  final List<Widget> _pages = [];

  // initialize atribute
  int _currentIndex = 0;
  bool _isFabVisible = true;
  bool _isSearching = false;

  // declaration attribute
  String _title;
  TabController _tabController;
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _title = 'Movies';
    _tabController = TabController(length: 2, vsync: this);

    _pages.addAll([
      MoviePage(),
      TvShowPage(),
      FavoritePage(controller: _tabController),
    ]);
    _textEditingController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();

    FavoriteDatabase.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildMainScreen();
  }

  Widget buildMainScreen() {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              if (_currentIndex != 2) ...[
                DefaultAppBar(
                  title: _isSearching ? buildSearchField() : buildTitle(_title),
                  leading: _isSearching ? buildLeading() : null,
                  actions: _isSearching ? null : buildActions(),
                )
              ] else ...[
                FavoriteAppBar(
                  title: _title,
                  controller: _tabController,
                )
              ]
            ];
          },
          body: NotificationListener<UserScrollNotification>(
            onNotification: (userScroll) {
              if (userScroll.direction == ScrollDirection.forward) {
                if (!_isFabVisible) {
                  setState(() => _isFabVisible = true);
                }
              } else if (userScroll.direction == ScrollDirection.reverse) {
                if (_isFabVisible) {
                  setState(() => _isFabVisible = false);
                }
              }

              return true;
            },
            child: _pages[_currentIndex],
          ),
        ),
      ),
      floatingActionButton: _isFabVisible && _currentIndex != 2
          ? FloatingActionButton(
              onPressed: () => _scrollController.jumpTo(0),
              child: Icon(Icons.arrow_upward_rounded),
              foregroundColor: accentColor,
              backgroundColor: primaryTextColor,
              tooltip: 'Go to top',
            )
          : null,
      bottomNavigationBar: ScrollToHide(
        controller: _scrollController,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            opacity: 1,
            color: primaryColor,
          ),
          unselectedIconTheme: IconThemeData(
            opacity: 1,
            color: secondaryColor,
          ),
          selectedFontSize: 0, // fix bug when clicking bottom nav label
          unselectedFontSize: 0, // fix bug when clicking bottom nav label
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_outlined),
              activeIcon: Icon(Icons.movie_creation),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_display_outlined),
              activeIcon: Icon(Icons.smart_display),
              label: 'TV Shows',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _isSearching = false;

              switch (index) {
                case 0:
                  _title = 'Movies';

                  break;
                case 1:
                  _title = 'Tv Shows';

                  break;
                case 2:
                  _tabController.index = 0;
                  _title = 'Favorites';

                  break;
              }
            });
          },
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/cickmovie_sm.png',
          width: 32,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: appBarTitleTextStyle,
        )
      ],
    );
  }

  Widget buildSearchField() {
    return Container(
      height: 40,
      child: TextField(
        controller: _textEditingController,
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          hintText: "Search...",
          filled: true,
          fillColor: dividerColor,
          suffixIcon: _textEditingController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  onPressed: () => _textEditingController.clear(),
                  icon: Icon(
                    Icons.close,
                    color: defaultTextColor,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildLeading() {
    return IconButton(
      onPressed: () => setState(() => _isSearching = false),
      icon: Icon(
        Icons.arrow_back,
        color: defaultTextColor,
      ),
      tooltip: 'Back',
    );
  }

  List<Widget> buildActions() {
    return <Widget>[
      IconButton(
        onPressed: () => setState(() => _isSearching = true),
        icon: Icon(
          Icons.search,
          color: defaultTextColor,
        ),
        tooltip: 'Search',
      )
    ];
  }
}
