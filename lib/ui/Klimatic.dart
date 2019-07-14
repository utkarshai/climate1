//any async function or method has to called in an async method
// any method when called it should not end by '()' this eg. has been editted but if in eg line no. 53 if there is no need to
// pass argument then it will call like i shown there
//press clt+b to get to the vfunction where it is defined
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';



import 'package:http/http.dart' as http;

import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => new _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(//allows to move over bridge
        new MaterialPageRoute<Map>(builder: (BuildContext context) { // also making the bridge
          // ch ange to Map instead of dynamic for this to work
      return new ChangeCity();
    }));
//
    if ( results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];

//      debugPrint("From First screen" + results['enter'].toString());


    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {
                _goToNextScreen(context);//_goToNextScreen;
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/umbrella.png',
              width: 490.0,
              height: 1200.0,// this written if in case height is longer in case of iios then it should work fine
              fit: BoxFit.fill,//this help us to cover the whole screen for the image no sspace will left behind
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              '${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),

          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          updateTempWidget(_cityEntered)// this will help to call the future builder which will build this container again when we come back to
          //this page again;

          //Container which will have our weather data
//          new Container(
//            //margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
//
//            child: ,
//          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=imperial';

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(// future bulder is here to receive the future materials
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {// snapshot is the snapshot of the future which we defined
          // in the line above it as that will return a future type map thus we have written map;
          //where we get all of the json data, we setup widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() +" F",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                            "Min: ${content['main']['temp_min'].toString()} F\n"
                            "Max: ${content['main']['temp_max'].toString()} F ",

                        style: extraData(),

                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
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
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),

                  //
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),

              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: new Text('Get Weather')),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle extraData() {
  return new TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 17.0);

}
TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 49.9);
}