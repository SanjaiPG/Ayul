import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ModernNavBar extends StatefulWidget {
  const ModernNavBar({super.key});

  @override
  State<ModernNavBar> createState() => _ModernNavBarState();
}

class _ModernNavBarState extends State<ModernNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Home", style: TextStyle(fontSize: 22))),
    Center(child: Text("Search", style: TextStyle(fontSize: 22))),
    Center(child: Text("Notifications", style: TextStyle(fontSize: 22))),
    Center(child: Text("Profile", style: TextStyle(fontSize: 22))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent, // 🔹 remove ripple
              highlightColor: Colors.transparent, // 🔹 remove highlight
              hoverColor: Colors.transparent, // 🔹 remove hover glow
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: false,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.personalcard),
                  label: 'Anatomap',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.health),
                  label: 'Medicines',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.document_text),
                  label: 'Diagnosis',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ModernNavBar()));
}
