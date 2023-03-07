import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nokhwook/features/engagement/word_reminder.dart';
import 'package:nokhwook/features/stages/random_stage.dart';
import 'package:nokhwook/features/stages/vocab_stage.dart';
import 'package:nokhwook/features/welcome/welcome.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/pages/settings.dart';
import 'package:nokhwook/services/notification_service.dart';

class Home extends StatefulWidget {
  final NotificationService notificationService;
  final WordReminder wordReminder;

  Home({super.key, required this.notificationService})
      : wordReminder = WordReminder(notificationService: notificationService);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Stream<int> reminders;
  int selectedTab = 0;

  late Future<Vocab> vocab;

  Future<Vocab> loadVocabulary() async {
    String vocab = await rootBundle.loadString('assets/vocab.csv');
    List<List<dynamic>> items = const CsvToListConverter().convert(vocab);

    return Vocab.parse(items);
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, initialIndex: 0, vsync: this);
    vocab = loadVocabulary().then((v) async {
      await widget.wordReminder.initialize(v);
      reminders = widget.wordReminder.reminders.stream.asBroadcastStream();
      reminders.listen((event) => switchTab(1));
      return v;
    });
  }

  switchTab(index) {
    setState(() {
      selectedTab = index;
    });

    tabController.animateTo(index,
        duration: const Duration(microseconds: 300), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: vocab,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scaffold(
                backgroundColor: Colors.amber[200],
                appBar: AppBar(
                  title: const Text('Let\'s practice'),
                  centerTitle: true,
                  backgroundColor: Colors.red[400],
                ),
                body: TabBarView(controller: tabController, children: [
                  Welcome(vocab: snapshot.data!),
                  VocabStage(
                    vocab: snapshot.data!,
                    currentWord: reminders,
                    // focusCallback: () => switchTab(1),
                  ),
                  RandomStage(vocab: snapshot.data!),
                  const Settings()
                ]),
                bottomSheet: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: false,
                  currentIndex: selectedTab,
                  onTap: switchTab,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        tooltip: 'Home',
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.library_books),
                        tooltip: 'Cards',
                        label: 'Cards'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.shuffle),
                        tooltip: 'Random',
                        label: 'Random'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), tooltip: 'Settings', label: 'Settings')
                  ],
                ),
              )
            : Container(
                color: Colors.red[400],
                child: const Center(
                  child: SpinKitCubeGrid(
                    color: Colors.white,
                    size: 80.0,
                  ),
                ),
              );
      });
}
