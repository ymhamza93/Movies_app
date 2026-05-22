import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/assets_manager.dart';
import 'package:movies_app/core/utils/color_manager.dart';
import 'package:movies_app/feature/home_screen/browse_tab/browse_tab.dart';
import 'package:movies_app/feature/home_screen/home_tab/home_tab.dart';
import 'package:movies_app/feature/home_screen/profile_tab/profile_tab.dart';
import 'package:movies_app/feature/home_screen/search_tab/search_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> theTabs = [HomeTab(), SearchTab(), BrowseTab(), ProfileTab()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: theTabs[_currentIndex],
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: ColorManager.backgroundNavigationBar,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ColorManager.yellow,
      unselectedItemColor: ColorManager.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconManager.homeIcon)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconManager.searchIcon)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconManager.browserIcon)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage(IconManager.profileIcon)),
          label: '',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: _onTab,
    );
  }

  void _onTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
