import 'dart:convert';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Object? parameters;
  Map data = {};

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)?.settings.arguments;
    data = data.isEmpty? jsonDecode(jsonEncode(parameters)): data;

    // set day time.
    bool isDayTime = data['isDayTime'];

    // set background image
    String backgroundImage = isDayTime? 'assets/day.jpg': 'assets/night.jpg';
    Color? backgroundColor = isDayTime? Colors.blueGrey[500]: Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover
              )
            ),
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Column(
              children: <Widget>[
                TextButton.icon(
                  onPressed: () async {
                    dynamic location = await Navigator.pushNamed(context, '/location');
                    setState(() {
                      data = {
                        'location': location['location'],
                        'flag': location['flag'],
                        'time': location['time'],
                        'isDayTime': location['isDayTime']
                      };
                    });
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.grey[200]
                  ),
                  label: Text(
                    'Edit Location',
                    style: TextStyle(
                      color: Colors.grey[200]
                    )
                  )
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['location'],
                      style: const TextStyle(
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                        color: Colors.white
                      ),)
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  data['time'],
                  style: const TextStyle(
                    fontSize: 66.0,
                    color: Colors.white
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}