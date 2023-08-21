import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/create_post/create_post.dart';
import 'package:profair/src/views/favorites/favorites.dart';
import 'package:profair/src/views/home/home.dart';
import 'package:profair/src/views/profile/profile.dart';
import 'package:profair/src/views/search/search.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  List<Widget> pageList = [
    const HomePage(),
    const Favorites(),
    const CreatePost(),
    const Search(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colorPrimary,
        unselectedItemColor: colorGreyDark,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favoritos',
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(label: 'Criar', icon: Icon(Icons.add_circle_outline_outlined), activeIcon: Icon(Icons.add_circle)),
          BottomNavigationBarItem(
            label: 'Descobrir',
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Perfil',
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
