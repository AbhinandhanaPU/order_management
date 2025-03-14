import 'package:flutter/material.dart';
import 'package:order_management/view/order_tracking/order_tracking_screen.dart';
import 'package:order_management/view/product_listing/product_list_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  var currentIndex = 0; // Track selected tab

  // List of screens corresponding to each navigation item
  List<Widget> tabWidgets = [
    ProductListScreen(),
    OrderTrackingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body content based on the selected tab - Displays the selected screen
      body: tabWidgets[currentIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottonNavBar(),
    );
  }

  Widget _buildBottonNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop_2),
          label: "My Orders",
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xfff9f6f2),
      selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      unselectedIconTheme: IconThemeData(color: Colors.grey.shade500),
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
}
