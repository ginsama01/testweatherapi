import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Api Call'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String baseUrl = 'api.openweathermap.org';
  final String API_KEY = "e45ecdc3bb276b3b0525f9b3d20a9d4a";

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Temperature info');
  Map<String, dynamic> data;

  Future<void> getData(String city) async {
    Map<String, String> parametes = {'q': city, 'appid': API_KEY};

    Uri uri = Uri.https(
      baseUrl,
      '/data/2.5/weather',
      parametes,
    );
    print(uri);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      print(json.decode(response.body)['weather'][0]['icon']);
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      setState(() {
        data = {"error": "Can't search this location"};
      });
      throw json.decode(response.body)['error']['message'];
    }
  }

  @override
  void initState() {
    super.initState();
    getData('Hanoi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customSearchBar,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar = ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type in city name...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onSubmitted: (String value) {
                            getData(value);
                          },
                        ),
                      );
                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text('Temperature info');
                    }
                  });
                },
                icon: customIcon)
          ],
        ),
        body: data != null
            ? (data['weather'] != null
                ? Center(
                    child: Column(children: [
                      Image.network("http://openweathermap.org/img/w/" +
                          data['weather'][0]['icon'] +
                          ".png"),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "${(data['main']['temp'] - 273.15).toStringAsFixed(1)}°",
                        style: TextStyle(
                          fontSize: 46.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "${data['name']}",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Divider(),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Wind",
                                  ),
                                  SizedBox(height: 18.0),
                                  Text(
                                    "Pressure",
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['wind']['speed']}",
                                  ),
                                  SizedBox(height: 18.0),
                                  Text(
                                    "${data['main']['pressure']}",
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Humidity",
                                  ),
                                  SizedBox(height: 18.0),
                                  Text(
                                    "Feels Like",
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['main']['humidity']}",
                                  ),
                                  SizedBox(height: 18.0),
                                  Text(
                                    "${(data['main']['feels_like'] - 273.15).toStringAsFixed(1)}",
                                  ),
                                ],
                              ),
                            ]),
                      )
                    ]),
                  )
                : Center(
                    child: Text(
                      "${data['error']}",
                    ),
                  ))
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor, // Red
                  ),
                ),
              ));
  }
}
