import 'package:flutter/material.dart';

void main() {
  runApp(Hedeyeti());
}

class Hedeyeti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyeti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF4ecdc4),    // Teal for primary color (AppBar and main accents)
          secondary: Color(0xFF292f36),  // Dark color for highlights if needed
          background: Color(0xFFfdfdfd), // Light background
        ),

        // Customize the AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4ecdc4),  // Teal AppBar
          iconTheme: IconThemeData(color: Colors.white), // White icons for contrast
          titleTextStyle: TextStyle(
            color: Colors.white,               // White title text
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Bottom Navigation Bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF4ecdc4), // Teal background color for the navbar
          selectedItemColor: Color(0xFFBFEDEA), // Dark color for the selected item
          unselectedItemColor: Colors.white,   // White for unselected items
        ),

        // Text theme with black as the default color for body text
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),  // Black color for main body text
          bodyMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(
            color: Colors.black, // Black for headers
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hedeyeti'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Page',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Page',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
