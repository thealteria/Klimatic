import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './util/utils.dart' as util;
// import './util/file.dart';

class Klimatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new KlimaticState();
  }
}

class KlimaticState extends State<Klimatic> {
  String _cityEntered;

  var textController = new TextEditingController();
  Future goToNext() async {
    Map result = await Navigator.push(context,
        new MaterialPageRoute<Map>(builder: (context) {
      return new ChangeCity();
    }));
    if (result != null && result.containsKey('enter')) {
      // print(result['enter'].toString());
      _cityEntered = result['enter'].toString();
      _cityEntered = _cityEntered[0].toUpperCase() + _cityEntered.substring(1);
    } else {
      print('Nothing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => goToNext(),
          ),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/umbrella.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
                '${_cityEntered == null ? util.defaultCity : _cityEntered}',
                style: _fontStyle(22.9, FontStyle.italic)),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          //container having weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 330.0, 0.0, 0.0),
            child: updateTemp(_cityEntered),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String api, String city) async {
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Widget updateTemp(String city) {
    return new FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    "${content['main']['temp']}°C",
                    style: _fontStyle(49.9, FontStyle.italic),
                  ),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()}\n"
                          "Max: ${content['main']['temp_max'].toString()}",
                      style: _fontStyle(17.0, FontStyle.normal),
                    ),
                  ),
                ),
                // new ListTile(
                //   title: new TextField(
                //     controller: textController,
                //     style: TextStyle(color: Colors.white),
                //     decoration: InputDecoration(labelText: "Enter name,"),
                //   ),
                // ),
                // new ListTile(
                //   title: new RaisedButton(
                //     onPressed: () {
                //       goToNext(context);
                //     },
                //     /*Navigator.push(
                //         context,
                //         new MaterialPageRoute(
                //             builder: (content) => new File(
                //                   name: "${textController.text}",
                //                 ))) */
                //     child: new Text("Press"),
                //   ),
                // ),
              ],
            ),
          );
        } else {
          return new Container();
        }
      },
    );
  }
}

class ChangeCity extends StatelessWidget {
  var cityController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("New act"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "City",
                    labelText: "Enter City",
                  ),
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  child: new Text("Get Weather"),
                  color: Colors.redAccent,
                  textColor: Colors.white70,
                  onPressed: () {
                    Navigator.pop(context, {'enter': cityController.text});
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle _fontStyle(double fontSize, FontStyle style) {
  return new TextStyle(
      color: Colors.white, fontSize: fontSize, fontStyle: style);
}
