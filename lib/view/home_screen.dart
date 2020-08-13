import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instaclone/generated/l10n.dart';
import 'package:instaclone/profile/pages/profile_page.dart';
import 'package:instaclone/view/activities/pages/activities_page.dart';
import 'package:instaclone/view/feed/pages/feed_page.dart';
import 'package:instaclone/view/post/pages/post_page.dart';
import 'package:instaclone/view/search/pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> _pages;
  int _currentIndex =0;

  @override
  void initState() {
    _pages = [
      FeedPage(),
      SearchPage(),
      PostPage(),
      ActivitiesPage(),
      ProfilePage(),
    ];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,//ボタンが動かない
        showSelectedLabels: false,//選択中のアイテムのタイトル出すかどうか
        showUnselectedLabels: false,//選択していないアイテムのタイトル出すかどうか
//        selectedItemColor: Colors.white,//選択中のアイテムの色変える
        currentIndex: _currentIndex,
        items:[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.igloo),
            title: Text(S.of(context).home)
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.searchengin),
              title: Text(S.of(context).search)
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.plusSquare),
              title: Text(S.of(context).add)
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart),
              title: Text(S.of(context).activities)
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              title: Text(S.of(context).user)
          ),
        ] ,
        onTap:(index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
