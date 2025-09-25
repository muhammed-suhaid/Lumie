import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TabScreen extends StatefulWidget {
  final List<Widget> pages;

  const TabScreen({super.key, required this.pages});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;

  //************************* Select Page *************************//
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //************************* Navigation Icon Widget *************************//
  Widget _navIcon(IconData icon, int index, ColorScheme colorScheme) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedPageIndex == index
            ? colorScheme.primary
            : colorScheme.onPrimary,
      ),
      onPressed: () => _selectPage(index),
    );
  }

  //************************* Build *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: widget.pages[_selectedPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(Iconsax.home, 0, colorScheme),
            _navIcon(Iconsax.heart, 1, colorScheme),
            _navIcon(Iconsax.message, 2, colorScheme),
            _navIcon(Iconsax.user, 3, colorScheme),
          ],
        ),
      ),
    );
  }
}
