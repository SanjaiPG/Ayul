import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSearchApp extends StatelessWidget {
  const GlassSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GlassSearchScreen(),
    );
  }
}

class GlassSearchScreen extends StatefulWidget {
  const GlassSearchScreen({super.key});

  @override
  State<GlassSearchScreen> createState() => _GlassSearchScreenState();
}

class _GlassSearchScreenState extends State<GlassSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _focused = false;
  List<String> _results = [];

  final List<String> dummyData = [
    "Apple",
    "Banana",
    "Orange",
    "Mango",
    "Pineapple",
    "Strawberry",
    "Blueberry",
    "Watermelon",
    "Papaya",
    "Kiwi",
    "Peach",
    "Cherry",
    "Lemon",
    "Grapes",
    "Guava",
  ];

  void _onSearchChanged(String query) {
    setState(() {
      _results = dummyData
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _focused = query.isNotEmpty || _focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient + blur
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xAA1E1E2F), Color(0x661E1E2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0)),
          ),

          // Search bar + results
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _focused ? 60 : size.height / 2 - 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Glass search bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _controller,
                          onChanged: _onSearchChanged,
                          onTap: () {
                            setState(() => _focused = true);
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(Icons.search, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Results list (only visible when focused)
                if (_focused)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: size.height * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _results[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
