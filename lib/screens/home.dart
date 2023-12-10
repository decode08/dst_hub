import 'package:dst_hub/main.dart';
import 'package:dst_hub/screens/profile.dart';
import 'package:dst_hub/screens/work.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const route = '/HomePage-Screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   int _selectedIndex = 0;
  final List<Widget> _screenOptions = <Widget>[
    WorkPage(),
    ProfilePage(),
  ];
  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: _screenOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.work), label: 'Work Track'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onTapItem,
        )
       
        );
  }
}
