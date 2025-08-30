import 'package:flutter/material.dart';
import 'starAnimation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StarsAnimationScreen(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(13),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(40, 63, 60, 60).withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 106, 106, 106),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_graph),
                label: "Graph",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: "Book"),
            ],
          ),
        ),
      ),
    );
  }
}
