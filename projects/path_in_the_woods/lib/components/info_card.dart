import 'package:flutter/material.dart';
import 'package:path_in_the_woods/components/simple_info.dart';
import 'package:tuple/tuple.dart';

class InfoCard extends StatelessWidget {
  final List<Tuple2> infoItems;

  const InfoCard({super.key, required this.infoItems});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 1.0, left: 1.0, right: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: infoItems.map(
            (e) => SimpleInfo(title: e.item1, value: e.item2)
          ).toList()
        ),
      ),
    );
  }
}