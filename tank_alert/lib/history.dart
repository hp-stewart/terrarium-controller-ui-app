import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'tank.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // database variables
  final databaseRef = FirebaseDatabase.instance.ref();

  final Future<FirebaseApp> _future = Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBMrIvuFyhpDja62FriCuBRkIjMGVV3GI8",
      authDomain: "smart-mini-vivarium.firebaseapp.com",
      projectId: "smart-mini-vivarium",
      storageBucket: "smart-mini-vivarium.appspot.com",
      databaseURL: "https://smart-mini-vivarium-default-rtdb.firebaseio.com/",
      messagingSenderId: "250727653884",
      appId: "1:250727653884:android:17d0e5fc6f2e5721011279",

    ),);

  //variables
  List<dynamic> dbData = [];
  List<Tank> tankData = [];
  List<charts.Series<Tank, String>> sensorChartData = [];
  List<charts.Series<Tank, String>> outputChartData = [];

  var numberOfDbItems = 0;
  var numberOfTankItems = 0;
  var numberOfChartItems = 0;

  var outputVariableDropdownValue = "red led";
  var sensorVariableDropdownValue = "light";
  var timePeriodDropDownValue = "today";
  String units = "percent";

  //functions
  getHistory() async {
    List<dynamic> result = [];
    DateTime now = DateTime.now();
    print("preparing to fetch history from firebase");
    if (timePeriodDropDownValue == "today") {
      print("time period: today");
      for (var i = 0; i <= now.hour; i++) {
        final snapshot = await databaseRef
            .child("history")
            .child("${now.year}")
            .child("${now.month}")
            .child("${now.day}")
            .child("${i}")
            .get();
        if (snapshot.value != null) {
          print("fetched data:  ${snapshot.value} ");
          result.add(snapshot.value);
        } else {
          print("failed to read schedule from firebase");
        }
      }
    }
    else if (timePeriodDropDownValue == 'last 24 hours') {
        print("time period: last 24 hours");
        for (var i = now.hour; i < 24; i++) {
          final snapshot = await databaseRef
              .child("history")
              .child("${now.year}")
              .child("${now.month}")
              .child("${now.day - 1}")
              .child("${i}")
              .get();
          if (snapshot.value != null) {
            print("fetched data:  ${snapshot.value} ");
            result.add(snapshot.value);
          } else {
            print("failed to read schedule from firebase");
          }
        }
      for (var i = 0; i < now.hour; i++) {
        final snapshot = await databaseRef
            .child("history")
            .child("${now.year}")
            .child("${now.month}")
            .child("${now.day}")
            .child("${i}")
            .get();
        if (snapshot.value != null) {
          print("fetched data:  ${snapshot.value} ");
          result.add(snapshot.value);
        } else {
          print("failed to read schedule from firebase");
        }
      }

    }
    else if (timePeriodDropDownValue == 'last 7 days') {
      print("time period: 7 days");
      for (var j = 7; j > 0; j--) {
        for (var i = 0; i < 24; i++) {
          final snapshot = await databaseRef
              .child("history")
              .child("${now.year}")
              .child("${now.month}")
              .child("${now.day - j}")
              .child("${i}")
              .get();
          if (snapshot.value != null) {
            print("fetched data:  ${snapshot.value} ");
            result.add(snapshot.value);
          } else {
            print("failed to read schedule from firebase");
          }
        }
      }

    }
    else if (timePeriodDropDownValue == 'yesterday') {
      print("time period: yesterday");
      for (var i = 0; i < 24; i++) {
        final snapshot = await databaseRef
            .child("history")
            .child("${now.year}")
            .child("${now.month}")
            .child("${now.day - 1}")
            .child("${i}")
            .get();
        if (snapshot.value != null) {
          print("fetched data:  ${snapshot.value} ");
          result.add(snapshot.value);
        } else {
          print("failed to read schedule from firebase");
        }
      }

    }
    else {
      Alert(
        context: context,
        title: "Alert",
        desc: "Error--Data does not exist",
      ).show();
      return 0;
    }
    return result;
  }

  List<Tank> packageDataInObjects() {
    List<Tank> result = [];
    if (dbData!=null){
      print("packaging ${numberOfDbItems} into Tank Objects");
      for (var i = 0; i < numberOfDbItems; i++) {
        var scanTime = dbData[i]['scan time'];
        DateTime dtScanTime = DateTime.parse(scanTime);

        var light = dbData[i]['sensors']["light"];
        var temp = dbData[i]['sensors']["temp"];
        var humidity = dbData[i]['sensors']["humidity"];
        var moisture = dbData[i]['sensors']["soil moisture"];

        var redLight = dbData[i]['outputs']["red led"];
        var blueLight = dbData[i]['outputs']["blue led"];
        var waterPump = dbData[i]['outputs']["pump"];
        var fan = dbData[i]['outputs']["fan"];


        print("scan time: ${dtScanTime}    light: ${light}   temp: ${temp}   humidity: ${humidity}   moisture: ${moisture}");
        print("red led: ${redLight}   blue led: ${blueLight}   water pump: ${waterPump}   fan: ${fan}");
        Tank t = Tank(dtScanTime, light, temp, humidity, moisture, redLight, blueLight, waterPump, fan);
        result.add(t);
      }

    } else {
      print("error--nothing to package");
    }
     return result;
  }

  @override
   Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: ListView(
                    children: [
                      SizedBox(height: 50),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children:[
                            TextButton(

                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black12,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Go to: Home", ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/');},
                            ),
                            TextButton(

                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Go to: Schedules", ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/schedule');
                                }

                            ),

                          ]
                      ), //Row with Nav Buttons
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children:[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children:[
                                    SizedBox(height: 20),
                                    Text("Output: ",
                                    ),
                                    DropdownButton<String>(
                                      value: outputVariableDropdownValue,
                                      items: <String>['red led', 'blue led', 'pump', 'fan']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          outputVariableDropdownValue = newValue!;
                                        });
                                      },
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children:[
                                    SizedBox(height: 20),
                                    Text("Sensor: ",
                                    ),
                                    DropdownButton<String>(
                                      value: sensorVariableDropdownValue,
                                      items: <String>['light', 'temp', 'humidity', 'soil moisture']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue == "temp") {
                                          units = "degrees C";
                                        } else {units = "percent";}
                                        setState(() {
                                          sensorVariableDropdownValue = newValue!;
                                        });
                                      },
                                    ),
                                  ]

                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children:[
                                    SizedBox(height: 20),
                                    Text("Time Period: ",
                                      ),
                                    DropdownButton<String>(
                                      value: timePeriodDropDownValue,
                                      items: <String>['today', 'yesterday', 'last 24 hours', 'last 7 days', 'last 30 days']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          timePeriodDropDownValue = newValue!;
                                        });
                                      },
                                    ),
                                  ]
                              ),
                            ),
                          ]
                      ), // Row with dropdown buttons for variable and time to be graphed
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.fromLTRB(60, 0, 60, 0),
                        child: TextButton(

                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black12,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Load History", ),
                            ),
                            onPressed: ()  async {
                              dbData = await getHistory();
                              numberOfDbItems = dbData.length;
                              tankData = packageDataInObjects();
                              numberOfTankItems = tankData.length;
                              String sensorVariable = sensorVariableDropdownValue.toString();
                              String outputVariable = outputVariableDropdownValue.toString();

                              sensorChartData = [charts.Series<Tank, String>(
                                id: "tank data",
                                data: tankData,
                                measureFn: (Tank tank, _) {
                                  if (sensorVariable == "light") {
                                    return tank.light;
                                  } else if (sensorVariable == "temp") {
                                    return tank.temp;
                                  } else if (sensorVariable == "humidity") {
                                    return tank.humidity;
                                  } else if(sensorVariable == "soil moisture") {
                                    return tank.moisture;
                                  }
                                },
                                domainFn: (Tank tank, _)=> tank.scanTime.toString()
                              ),];
                              print("updating ui");

                              setState(() {
                              });
                              outputChartData = [charts.Series<Tank, String>(
                                id: "tank data",
                                data: tankData,
                                measureFn: (Tank tank, _) {
                                  if (outputVariable == "red led") {
                                    return tank.redLight;
                                  } else if (outputVariable == "blue led") {
                                    return tank.blueLight;
                                  } else if (outputVariable == "pump") {
                                    return tank.waterPump;
                                  } else if(outputVariable == "fan") {
                                    return tank.fan;
                                  }
                                },
                                domainFn: (Tank tank, _)=> tank.scanTime.toString(),
                              ),];
                              print("updating ui");

                              setState(() {
                              });
                            }

                        ),
                      ), // Button to Load History for selected var & time
                      Text(
                        "Sensor Graph: ",
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,

                      ), //"sensor graph"
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(height: 800, child: charts.BarChart(sensorChartData, domainAxis: charts.OrdinalAxisSpec(
                          renderSpec: charts.SmallTickRendererSpec(labelRotation: 89)))),
                      ),
                      Text(
                        "Output Graph: ",
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,

                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: SizedBox(height: 800, child: charts.BarChart(outputChartData,
                            domainAxis: charts.OrdinalAxisSpec(
                                renderSpec: charts.SmallTickRendererSpec(labelRotation: 89)))),
                      ),//"sensor graph"
                      /*Padding(
                        padding: EdgeInsets.all(15.0),
                        child: SizedBox(height: 800, child: charts.BarChart(outputChartData,
                          domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(labelRotation: 89)))),
                      ),*/ // graph inside padding
                      //SizedBox(height: 20),
                      Text(
                        "Sensor Data: ",
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,

                      ), //"sensor data"
                      ListView.builder(
                        itemCount: numberOfDbItems,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children:[
                                  Text("Time: ${dbData[index]['scan time']}"),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children:[
                                  Text("Light: ${dbData[index]['sensors']["light"]} %",
                                    softWrap: true,
                                  ),
                            Text("Temp: ${dbData[index]['sensors']["temp"]} deg C",
                              softWrap: true,
                            ),
                            Text("Humidity: ${dbData[index]['sensors']["humidity"]} %",
                              softWrap: true,
                            ),
                            Text("Soil moisture: ${dbData[index]['sensors']["soil moisture"]} %",
                                softWrap: true)
                                      ]
                                  ),


                                ]
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Output Data: ",
                        textAlign: TextAlign.center,
                        textScaleFactor: 2,

                      ), //"sensor data"
                      ListView.builder(
                        itemCount: numberOfDbItems,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children:[
                                  Text("Time: ${dbData[index]['scan time']}"),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text("Red LED: ${dbData[index]['outputs']["red led"]} ",
                                        softWrap: true,
                                      ),
                                      Text("Blue LED: ${dbData[index]['outputs']["blue led"]} ",
                                        softWrap: true,
                                      ),
                                      Text("water pump: ${dbData[index]['outputs']["pump"]}",
                                        softWrap: true,
                                      ),
                                      Text("fan: ${dbData[index]['outputs']["fan"]}",
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ]
                            ),
                          );
                        },
                      ),
                    ]
                ),
              );
            }

          }
      ),
    );
  }
}
