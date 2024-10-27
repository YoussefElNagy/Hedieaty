import 'package:flutter/material.dart';
import 'components/Home.dart';
import 'components/EventPage.dart';
import 'components/Profile.dart';



void main() {
  runApp(Hedeyeti());
}

class Hedeyeti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyeti',
      debugShowCheckedModeBanner: false,
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
          backgroundColor: Color(0xFFfdfdf6), // Teal background color for the navbar
          unselectedItemColor: Color(0xFF9FE5DF), // Dark color for the selected item
          selectedItemColor: Color(0xFF4ecdc4),   // White for unselected items
        ),

        // Text theme with black as the default color for body text
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF292f36)),  // Black color for main body text
          bodyMedium: TextStyle(color: Color(0xFF292f36)),
          titleLarge: TextStyle(
            color: Color(0xFF292f36), // Black for headers
          ),
          headlineLarge: TextStyle(
            color: Color(0xFF292f36),
            fontWeight: FontWeight.w600// Black for headers
          ),
          headlineMedium: TextStyle(
              color: Color(0xFF292f36),
              fontWeight: FontWeight.w500// Black for headers
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
    Home(),
    Events(),
    Profile(),
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
        title: Text('Hedeyeti',style: TextStyle(
          fontSize: 30
        ),),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Events',
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



