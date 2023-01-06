import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [
    WorldTime(url: 'Asia/Bangkok', location: 'Bangkok', flag: 'thailand.png'),
    WorldTime(url: 'Asia/Kolkata', location: 'Kolkata', flag: 'india.png'),
    WorldTime(url: 'Australia/Sydney', location: 'Sydney', flag: 'australia.png'),
    WorldTime(url: 'Asia/Ho_Chi_Minh', location: 'Ho Chi Minh', flag: 'vietnam.png'),
    WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', flag: 'indonesia.png'),
  ];

  void updateLocation(index) async {
    WorldTime instance = locations[index];
    
    // Update the current time
    await instance.getTime();
    
    Navigator.pop(context, {
        'location': instance.location,
        'flag': instance.flag,
        'time': instance.time,
        'isDayTime': instance.isDayTime
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build triggered');

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Choose a location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                updateLocation(index);
              },
              title: Text(locations[index].location),
              leading: CircleAvatar(
                foregroundImage: AssetImage('assets/flags/${locations[index].flag}'),
              ),
            ),
          );
        }
      )
    );
  }
}