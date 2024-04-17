// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rust_toolkit/pages/battlemetrics.dart';
import 'package:rust_toolkit/pages/crafting.dart';
import 'package:rust_toolkit/pages/decaying.dart';
import 'package:rust_toolkit/pages/eco_raiding.dart';
import 'package:rust_toolkit/pages/raiding.dart';
import 'package:rust_toolkit/player_details_page.dart';
import 'package:rust_toolkit/recycle_calculator.dart';
//import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Crafting(),
    Raiding(),
    RecycleCalculatorPage(),
    // EcoRaiding(),
    Decaying(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final double padding = size.width * 0.04; // 4% of screen width
    final double iconSize = size.width * 0.06; // 6% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width
    final double screenMaxIcon = screenWidth < 500.0 ? iconSize : 26.0;
    final double screenMaxFont = screenWidth < 500.0 ? fontSize : 24.0;
    final double screenMaxPadding = screenWidth < 500.0 ? padding : 16.0;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Text(
          "RUST TOOLKIT",
          style: TextStyle(
            fontSize: fontSize * 1.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade300,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade300,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.leaf),
              title: Text(
                'Eco-Raiding',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EcoRaiding()),
                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.magnifyingGlassChart),
              title: Text(
                'BattleMetrics',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BattleMetrics()),
                );
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.magnifyingGlass),
              title: Text(
                'Look Up Player',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerDetailsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: GNav(
        textStyle: TextStyle(
            fontSize: screenMaxFont,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        gap: screenMaxPadding,
        backgroundColor: Colors.deepPurple.shade300,
        color: Colors.black26,
        activeColor: Colors.white,
        onTabChange: _navigateBottomBar,
        tabs: [
          GButton(
            icon: FontAwesomeIcons.hammer,
            text: "Crafting",
            iconSize: screenMaxIcon,
          ),
          GButton(
            icon: FontAwesomeIcons.explosion,
            text: "Raiding",
            iconSize: screenMaxIcon,
          ),
          GButton(
            icon: FontAwesomeIcons.recycle,
            text: "Recycle",
            iconSize: screenMaxIcon,
          ),
          GButton(
            icon: FontAwesomeIcons.houseCrack,
            text: "Decaying",
            iconSize: screenMaxIcon,
          ),
        ],
      ),
    );
  }
}
