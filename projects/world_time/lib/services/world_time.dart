import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the UI.
  String flag; // url to asset flag icon.
  String url; // location url for the API endpoint.

  late String time; // time at the location.
  late bool isDayTime; // indicates whether it's daytime.

  WorldTime({required this.url, required this.location, required this.flag});

  Future<void> getTime() async {
    try {

      Uri uri = Uri.http(
        'worldtimeapi.org',
        '/api/timezone/$url'
      );
      Map<String, String> headers = {
        "HttpHeaders.contentTypeHeader": "application/json"
      };
      Response response = await get(uri, headers: headers);
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'];

      print('datetime is $datetime');
      print('utc_offset is $offset');

      int hours = int.parse(offset.substring(1, 3));
      int minutes = int.parse(offset.substring(4));

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: hours, minutes: minutes));
      print('parsed datetime in $now');

      // set the time property.
      time = DateFormat.jm().format(now);
      isDayTime = now.hour>6 && now.hour<20? true: false;
    }
    catch (e) {
        time = 'error loading data';
        isDayTime = false;
    }
  }
}