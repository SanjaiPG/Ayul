import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'starAnimation.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            const StarsAnimationScreen(),

            IndexedStack(
              index: _selectedIndex,
              children: const [
                Center(child: Text("")),
                SearchPage(),
                Center(child: Text("")),
              ],
            ),
          ],
        ),
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
              items: [
                BottomNavigationBarItem(
                  icon: AnimatedScale(
                    scale: _selectedIndex == 0 ? 1.3 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: const Icon(Iconsax.activity),
                  ),
                  label: "Graph",
                ),
                BottomNavigationBarItem(
                  icon: AnimatedScale(
                    scale: _selectedIndex == 1 ? 1.3 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: const Icon(Icons.search),
                  ),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: AnimatedScale(
                    scale: _selectedIndex == 2 ? 1.3 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: const Icon(Icons.book),
                  ),
                  label: "Books",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
