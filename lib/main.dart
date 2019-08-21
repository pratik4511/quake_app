import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';


Map _data;
List _features;

void main() async {
  _data = await getQuake();
  _features = _data['features'];
  print(_data['features'][0]['properties']);

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
//    debugShowCheckedModeBanner: false,
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
            ),
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int position) {
            // CREATING ROWS FOR OUR LIST //
            if (position.isOdd) return new Divider();
            final index =
                position ~/ 2; // dividing each of the data with index //

            // ---> these methods used to display time in microseconds / date / time etc. from the web (JSON Parsing Data) <----//
            var format = new DateFormat.yMMMMd(); // <--- skeleton ("yMd") or say differenr formats //
            var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time'] * 1000));
            // ------------------------------------------------------------------------------------------------- //
            // https://stackoverflow.com/questions/45357520/dart-converting-milliseconds-since-epoch-unix-timestamp-into-human-readable//

            return new ListTile(
              title: new Text(
                "Places:${_features[index]['properties']['place']}",
                style: new TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 20.5,
                    fontStyle: FontStyle.normal,
                    color: Colors.blueGrey.shade600),
              ),
              // -------> to add subtitles //
              subtitle: new Text(
                "Mag:${_features[index]['properties']['mag']}",
                style: new TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w100,
                    color: Colors.blue.shade300),
              ),

              // --------> to add leading in circular //
              leading: new CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 55,
                child: new Text(
                  "At:$date",
                  style: new TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<Map> getQuake() async {
  String apiurl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiurl);
  return json.decode(response.body);
}
