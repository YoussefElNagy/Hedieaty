import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/Home.dart';
import 'components/EventPage.dart';
import 'components/Profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'components/LoginScreen.dart';

void firebaseInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() {
  firebaseInit();
  runApp(Hedieaty());
}

class Hedieaty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF4ecdc4), // Teal for primary color
          secondary: Color(0xFF292f36), // Dark color for highlights if needed
          tertiary: Color(0xFFBEEFEB), // Accent color for other UI elements
          surface: Color(0xFFfdfdfd), // Light background
        ),

        // AppBar customization
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4ecdc4),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Bottom Navigation Bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFfdfdf6),
          unselectedItemColor: Color(0xFF9FE5DF),
          selectedItemColor: Color(0xFF4ecdc4),
        ),

        // Text theme using Google Fonts
        textTheme: GoogleFonts.cairoTextTheme(
          TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF292f36)),
            bodyMedium: TextStyle(color: Color(0xFF292f36)),
            titleLarge: TextStyle(
              color: Color(0xFF292f36),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: TextStyle(
              color: Color(0xFF292f36),
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: TextStyle(
              color: Color(0xFF292f36),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFfdfdfd), // Background for input fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF4ecdc4), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF4ecdc4), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          labelStyle: TextStyle(color: Color(0x69292f36)),
          floatingLabelStyle: TextStyle(
            color: Color(0xFF4ecdc4), // Label color when focused
          ),  // Label text style
        ),

      ),
      home: LoginScreen(),
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
        title: Text(
          'Hedieaty',
          style: GoogleFonts.cairo(fontSize: 30), // Google Font for AppBar title
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
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
