import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:nokhwook/features/preferences/app_preferences.dart';
import 'package:nokhwook/features/stages/random_stage.dart';
import 'package:nokhwook/features/welcome/welcome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Stream<int> reminders;
  late StreamSubscription reminderSubscription;

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
        length: 3,
        initialIndex: selectedTab,
        vsync: this,
        animationDuration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    tabController.dispose();
    // reminderSubscription.cancel();

    super.dispose();
  }

  switchTab(index) {
    setState(() {
      selectedTab = index;
    });

    tabController.animateTo(index, curve: Curves.slowMiddle);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Let\'s practice'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: AdaptiveTheme.of(context).toggleThemeMode,
                icon: const Icon(Icons.brightness_auto_rounded))
          ],
        ),
        // Check out TabBar: https://docs.flutter.dev/cookbook/design/tabs
        body: TabBarView(
            controller: tabController,
            children: const [Welcome(), RandomStage(), AppPreferences()]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: selectedTab,
          onTap: switchTab,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), tooltip: 'Home', label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shuffle),
                tooltip: 'Random Cards',
                label: 'Random Cards'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                tooltip: 'Preferences',
                label: 'Preferences')
          ],
        ),
      );
}
