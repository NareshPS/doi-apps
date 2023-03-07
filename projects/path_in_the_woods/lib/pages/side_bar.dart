import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle
              ),
              child: const Icon(
                Icons.account_circle,
                semanticLabel: 'Hello',
              ),
            ),
            accountName: Text(
              'Naresh'.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            accountEmail: const Text(''),
          ),
          ListTile(
            title: const Text('Active Track'),
            leading: const Icon(Icons.location_on),
            onTap: () {
              Navigator.pushNamed(context, '/active_track_loading');
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: const Text('My Tracks'),
            leading: const Icon(Icons.directions_walk),
            onTap: () {
              Navigator.pushNamed(context, '/track_list');
              Scaffold.of(context).closeDrawer();
            },
          ),
        ],
      ),
    );
  }
}