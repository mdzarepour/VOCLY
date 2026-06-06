import 'package:flutter/material.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/constants/const_strings.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/vocabulary/view/screens/home_screen.dart';

class WarpperScreen extends StatefulWidget {
  const WarpperScreen({super.key});

  @override
  State<WarpperScreen> createState() => _WarpperScreenState();
}

class _WarpperScreenState extends State<WarpperScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int _selectedScreenIndex = 0;
  int _selectedTileIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: _drawerMenu(),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedScreenIndex,
          children: [
            HomeScreen(onTap: () => _key.currentState!.openDrawer()),
            Container(color: Colors.red, child: Text(UIStrings.data)),
            Container(color: Colors.blue, child: Text(UIStrings.data)),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _drawerMenu() {
    return Drawer(
      backgroundColor: ConstUiColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Column(
          children: [
            Text(style: AppTextTheme.headlineSmall, 'VOCLY'),
            const SizedBox(height: 30),
            _DrawerTile(
              isSelected: _selectedTileIndex == 0,
              onTap: () => _changeSelectedTileIndex(index: 0),
              icon: Icons.settings,
              title: UIStrings.settings,
            ),
            const SizedBox(height: 10),
            _DrawerTile(
              isSelected: _selectedTileIndex == 1,
              onTap: () => _changeSelectedTileIndex(index: 1),
              icon: Icons.send_rounded,
              title: UIStrings.shareToFriends,
            ),
            const SizedBox(height: 10),
            _DrawerTile(
              isSelected: _selectedTileIndex == 2,
              onTap: () => _changeSelectedTileIndex(index: 2),
              icon: Icons.battery_charging_full_outlined,
              title: UIStrings.donationToCreator,
            ),
            const SizedBox(height: 10),
            _DrawerTile(
              isSelected: _selectedTileIndex == 3,
              onTap: () => _changeSelectedTileIndex(index: 3),
              icon: Icons.phone,
              title: UIStrings.helpAndFeedback,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ConstUiColors.backgroundColor2, width: 1),
        ),
        color: ConstUiColors.forthColor,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _changeSelectedScreenIndex(index: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 25,
                    _selectedScreenIndex == 0
                        ? Icons.home
                        : Icons.home_outlined,
                  ),
                  Text(style: AppTextTheme.titleSmall, UIStrings.home),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _changeSelectedScreenIndex(index: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 25,
                    _selectedScreenIndex == 1
                        ? Icons.school
                        : Icons.school_outlined,
                  ),
                  Text(style: AppTextTheme.titleSmall, UIStrings.practice),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _changeSelectedScreenIndex(index: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 25,
                    _selectedScreenIndex == 2
                        ? Icons.assignment
                        : Icons.assignment_outlined,
                  ),
                  Text(style: AppTextTheme.titleSmall, UIStrings.exam),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeSelectedScreenIndex({required final int index}) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  void _changeSelectedTileIndex({required final int index}) {
    setState(() {
      _selectedTileIndex = index;
    });
  }
}

class _DrawerTile extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final String title;
  final bool isSelected;

  const _DrawerTile({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 55,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: isSelected ? ConstUiColors.firsColor : Colors.transparent,
        ),
        child: Row(
          spacing: 5,
          children: [
            Icon(size: 20, icon, color: getTileColor()),
            Text(
              style: AppTextTheme.titleMedium.copyWith(color: getTileColor()),
              title,
            ),
          ],
        ),
      ),
    );
  }

  Color getTileColor() {
    return isSelected ? ConstUiColors.forthColor : ConstUiColors.firsColor;
  }
}
