import 'package:flutter/material.dart';
// import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
import 'package:parliament_app/src/features/home/presentation/pages/dashboard_screen.dart';
import 'package:parliament_app/src/features/home/presentation/pages/offender_screen.dart';
import 'package:parliament_app/src/features/home/presentation/pages/parent_map_screen.dart';
import 'package:parliament_app/src/features/home/presentation/widgets/bottom_navigation_widget.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isMapScreen: _selectedIndex == 1,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(onItemTapped: _onItemTapped);
      case 1:
        return const ParentMapScreen();
      case 2:
        return OffenderScreen();
      default:
        return DashboardScreen(onItemTapped: _onItemTapped);
    }
  }
}
