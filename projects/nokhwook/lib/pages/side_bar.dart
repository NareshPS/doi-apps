import 'package:flutter/material.dart';
import 'package:nokhwook/utils/subset.dart';
import 'package:nokhwook/utils/word.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatelessWidget {
  final List<Word<WordItem>> words;
  final WordSubset subset;

  SideBar({super.key, required this.words}): subset = WordSubset(words: words);

  List<int> resolveRandomSubset(SharedPreferences? prefs) {
    List<String> randomWords = prefs?.getStringList('random') ?? [];

    if (randomWords.isEmpty) {
      randomWords = subset.random().map((e) => e.toString()).toList();
      prefs?.setStringList('random', randomWords);
    }

    return randomWords.map((e) => int.parse(e),).toList();
  }

  List<int> resolveMemorizedSubset(SharedPreferences? prefs) {
    return (prefs?.getStringList('memorized') ?? []).map((e) => int.parse(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) => ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Colors.grey[600],
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
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey[600],
                child: const ClipOval(
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
            ...[
              // All Words
              <String, dynamic>{
                'category': 'All Words',
                'words': words,
                'subset': List.generate(words.length, (i) => i),
                'iconData': Icons.home
              },
              // Random
              <String, dynamic>{
                'category': 'Random Words',
                'words': words,
                'subset': resolveRandomSubset(snapshot.data),
                'iconData': Icons.shuffle
              },
              // Random
              <String, dynamic>{
                'category': 'Memorized Words',
                'words': words,
                'subset': resolveMemorizedSubset(snapshot.data),
                'iconData': Icons.check_circle
              },
            ].map(
              (e) => SideBarItem(
                category: e['category'],
                words: e['words'],
                subset: e['subset'],
                iconData: e['iconData']
              )
            )
            // ListTile(
            //   title: const Text('Home'),
            //   leading: Icon(Icons.home, color: Colors.grey[600]),
            //   onTap: () {
            //     Navigator.pushReplacementNamed(
            //       context,
            //       '/home', 
            //       arguments: {
            //         'category': 'All Words',
            //         'words': words,
            //         'subset': List.generate(words.length, (i) => i)
            //       }
            //     );
            //     Scaffold.of(context).closeDrawer();
            //   },
            // ),
            // ListTile(
            //   title: const Text('Random Words',),
            //   leading: Icon(Icons.shuffle, color: Colors.grey[600]),
            //   onTap: () {
            //     Navigator.pushReplacementNamed(
            //       context,
            //       '/home', 
            //       arguments: {
            //         'category': 'Random Words',
            //         'words': words,
            //         'subset': subset.random() 
            //       }
            //     );
            //     Scaffold.of(context).closeDrawer();
            //   },
            // ),
            // FutureBuilder(
            //   future: SharedPreferences.getInstance(),
            //   builder: (context, snapshot) =>
            //       ListTile(
            //         title: const Text('Memorized'),
            //         leading: Icon(Icons.check_circle, color: Colors.grey[600]),
            //         onTap: () {
            //           List<int> indices = (snapshot.data?.getStringList('memorized') ?? [])
            //           .map<int>((e) => int.parse(e)).toList();
      
            //           Navigator.pushReplacementNamed(
            //             context,
            //             '/home', 
            //             arguments: {
            //               'category': 'Memorized',
            //               'words': words,
            //               'subset': snapshot.hasData? subset.memorized(indices): []
            //             }
            //           );
            //           Scaffold.of(context).closeDrawer();
            //         },
            //       )
            // ),
          ],
        ),
      ),
    );
  }
}

class SideBarItem extends StatelessWidget {
  final String category;
  final List<Word<WordItem>> words;
  final List<int> subset;
  final IconData iconData;
  final SharedPreferences? prefs;

  const SideBarItem({
      super.key,
      required this.category,
      required this.words,
      required this.subset,
      required this.iconData,
      this.prefs
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category),
      leading: Icon(iconData, color: Colors.grey[600]),
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/home', 
          arguments: {
            'category': category,
            'words': words,
            'subset': subset
          }
        );
        Scaffold.of(context).closeDrawer();
      },
    );
  }
}