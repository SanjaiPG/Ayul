import 'dart:ui';
import 'package:flutter/material.dart';
import 'content.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
      if (query.isEmpty) {
        _results.clear();
        _focused = false; // back to center, play with this to adjust behavior
      } else {
        _results = dummyData
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _focused = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: _focused ? 60 : size.height / 2 - 30,
          left: 20,
          right: 20,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        40,
                        63,
                        60,
                        60,
                      ).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: _onSearchChanged,
                            onTap: () => setState(() => _focused = true),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_focused)
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: size.height * 0.6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          40,
                          63,
                          60,
                          60,
                        ).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.2,
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(itemName: _results[index]),
                                ),
                              );
                            },
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
    );
  }
}
