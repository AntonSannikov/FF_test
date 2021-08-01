import 'package:ff_test/app_icons.dart';
import 'package:ff_test/screens/home_screen/pages/chat_page/ui.dart';
import 'package:ff_test/screens/home_screen/pages/dietary_page/ui.dart';
import 'package:ff_test/screens/home_screen/pages/map_page/ui.dart';
import 'package:ff_test/screens/home_screen/pages/news_page/ui.dart';
import 'package:ff_test/screens/home_screen/pages/training_page/ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  //
  GlobalKey<ScaffoldMessengerState>? _homeScaffoldKey;
  PageController? _pageController;
  int _selectedPageIndex = 0;

  //
  //
  // OVERRIDED METHODS ---------------------------------------------------------
  //
  //
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();
  }

  //
  //
  @override
  void dispose() {
    super.dispose();
  }

  //
  //############################################################################
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _homeScaffoldKey,
      child: Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedPageIndex = index);
            },
            children: [
              NewsPage(
                homeScaffoldKey: _homeScaffoldKey,
              ),
              DietaryPage(),
              ChatPage(),
              TrainingPage(),
              MapPage()
            ]),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPageIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            elevation: 5,
            onTap: (index) => onBottomNavBarItemTapped(index),
            items: [
              BottomNavigationBarItem(
                  label: 'news', icon: Icon(MyIcons.news_icon)),
              BottomNavigationBarItem(
                  label: 'apple', icon: Icon(MyIcons.apple_icon)),
              BottomNavigationBarItem(
                  label: 'person', icon: Icon(MyIcons.person_icon)),
              BottomNavigationBarItem(
                  label: 'training', icon: Icon(MyIcons.training_icon)),
              BottomNavigationBarItem(
                  label: 'map', icon: Icon(MyIcons.map_icon)),
            ]),
      ),
    );
  }

  //
  //
  // METHODS -------------------------------------------------------------------
  //
  //
  void onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
      _pageController!.animateToPage(index,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    });
  }
}
