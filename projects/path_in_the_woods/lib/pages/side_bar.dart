import 'package:flutter/material.dart';
import 'package:path_in_the_woods/pages/active_track_loading.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                'Naresh'.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[100],
                  height: 1.5,
                  letterSpacing: 1.35,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            accountEmail: const Text(''),
            currentAccountPicture: const CircleAvatar(
              child: ClipOval(
                child: Icon(Icons.account_circle),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/side_bar_background.jpg')
              )
            ),
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