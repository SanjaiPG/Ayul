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
    _buildPage("Dashboard", Iconsax.home),
    _buildPage("Anatomap", Iconsax.personalcard),
    _buildPage("Medicines", Iconsax.health),
    _buildPage("Diagnosis", Iconsax.document_text),
  ];

  static Widget _buildPage(String title, IconData icon) {
    return Container(
      key: ValueKey(title),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: Color(0xFF006D77)),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF023047),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Welcome to the $title section. Learn and explore medical resources.",
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FA),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
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
              blurRadius: 12,
              offset: Offset(0, -3),
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
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Color(0xFF006D77),
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: false,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.home),
                  label: 'Dashboard',
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
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFF006D77),
        scaffoldBackgroundColor: Color(0xFFF6F9FA),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      ),
      home: ModernNavBar(),
    ),
  );
}
