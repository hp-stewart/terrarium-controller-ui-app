import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.ref();

  var lastScanTime = "---";
  var temp = 23;
  var humidity = 84;
  var light = 65;
  var moisture = 36;

  var redLightsOn = "---";
  var blueLightsOn = "---";
  var pumpOn = "---";
  var fanOn = "---";


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


  getlastScanTime() async {
    print("fetching last scan time from firebase");
    final snapshot = await databaseRef.child("current status").child("time").get();
    if (snapshot.value != null) {
      print("fetched time: ${snapshot.value} degrees C");
      return await snapshot.value;
    } else {print("failed to read last scan time from firebase");}
  }
  getCurrentTempReading() async {
    print("fetching temp from firebase");
    final snapshot = await databaseRef.child("current status").child("sensors").child("temp").get();
    if (snapshot.value != null) {
      print("fetched temp: ${snapshot.value} degrees C");
      return await snapshot.value;
    } else {print("failed to read temp from firebase");}
  }
  getCurrentHumidityReading() async {
    print("fetching humidity from firebase");
    final snapshot = await databaseRef.child("current status").child("sensors").child("humidity").get();
    if (snapshot.value != null) {
      print("fetched humidity: ${snapshot.value} %");
      return await snapshot.value;
    } else {print("failed to read humidity from firebase");}
  }
  getCurrentLightReading() async {
    print("fetching light from firebase");
    final snapshot = await databaseRef.child("current status").child("sensors").child("light").get();
    if (snapshot.value != null) {
      print("fetched light: ${snapshot.value} %");
      return await snapshot.value;
    } else {print("failed to read light from firebase");}
  }
  getCurrentMoistureReading() async {
    print("fetching soil moisture from firebase");
    final snapshot = await databaseRef.child("current status").child("sensors").child("soil moisture").get();
    if (snapshot.value != null) {
      print("fetched moisture: ${snapshot.value} %");
      return await snapshot.value;
    } else {print("failed to read soil from firebase");}
  }
  getCurrentRedLedState() async {
    String result;
    print("fetching red led state from firebase");
    final snapshot = await databaseRef.child("current status").child("outputs").child("red led").get();
    if (snapshot.value != null) {
      print("fetched state: ${snapshot.value}");
      if (snapshot.value == 1) {
        result = "ON";
      } else { result = "OFF";}
      return result;
    } else {print("failed to read red light state from firebase");}
  }
  getCurrentBlueLedState() async {
    String result;
    print("fetching blue led state from firebase");
    final snapshot = await databaseRef.child("current status").child("outputs").child("blue led").get();
    if (snapshot.value != null) {
      print("fetched state: ${snapshot.value}");
      if (snapshot.value == 1) {
        result = "ON";
      } else { result = "OFF";}
      return result;
    } else {print("failed to read blue light state from firebase");}
  }
  getCurrentPumpState() async {
    String result;
    print("fetching water pump state from firebase");
    final snapshot = await databaseRef.child("current status").child("outputs").child("pump").get();
    if (snapshot.value != null) {
      print("fetched state: ${snapshot.value}");
      if (snapshot.value == 1) {
        result = "ON";
      } else { result = "OFF";}
      return result;
    } else {print("failed to read water pump state from firebase");}
  }
  getCurrentFanState() async {
    String result;
    print("fetching fan state from firebase");
    final snapshot = await databaseRef.child("current status").child("outputs").child("fan").get();
    if (snapshot.value != null) {
      print("fetched state: ${snapshot.value}");
      if (snapshot.value == 1) {
        result = "ON";
      } else { result = "OFF";}
      return result;
    } else {print("failed to read fan state from firebase");}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Container(
                  child: ListView(
                      children: <Widget>[
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween
                          ,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(60, 0, 30, 0),
                              child: TextButton(

                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("History", style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  onPressed: ()  {
                                    Navigator.pushNamed(context, "/history");
                                  }
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(30, 0, 60, 0),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Schedule", style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  onPressed: ()  {
                                    Navigator.pushNamed(context, '/schedule');

                                  }

                              ),
                            ),
                          ],
                        ),
                        Text(
                            "Last Scan: ${lastScanTime}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.fromLTRB(60, 0, 60, 0),
                          child: TextButton(

                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black12,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Sync Data", style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            onPressed: ()  async {
                              lastScanTime = await getlastScanTime();
                              temp = await getCurrentTempReading();
                              humidity = await getCurrentHumidityReading();
                              light = await getCurrentLightReading();
                              moisture = await getCurrentMoistureReading();
                              redLightsOn = await getCurrentRedLedState();
                              blueLightsOn = await getCurrentBlueLedState();
                              pumpOn = await getCurrentPumpState();
                              fanOn = await getCurrentFanState();
                              setState(() {
                              });
                            }

                          ),
                        ),
                        Text(
                          "Sensor Data: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.indigoAccent,
                              margin: EdgeInsets.fromLTRB(15, 10, 5, 10) ,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text("Temperature",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 15),
                                    Icon(Icons.thermostat_outlined, size: 50),
                                    SizedBox(height: 15),
                                    Text("${temp} deg C",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.teal,
                              margin: EdgeInsets.fromLTRB(5, 10, 5, 10) ,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Text("Humidity",                                      style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 15),
                                  Icon(Icons.air, size: 50),
                                  SizedBox(height: 15),
                                  Text("${humidity} %",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.yellow,
                              margin: EdgeInsets.fromLTRB(5, 10, 5, 10) ,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Text("Light",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 15),
                                  Icon(Icons.lightbulb, size: 50),
                                  SizedBox(height: 15),
                                  Text("${light} %",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.lightBlueAccent,
                              margin: EdgeInsets.fromLTRB(5, 10, 5, 15) ,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Text("Soil Moisture",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 15),
                                  Icon(Icons.water, size: 50),
                                  SizedBox(height: 15),
                                  Text("${moisture} %",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ],
                              ),
                            ),
                          ]
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Output State: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                color: Colors.red,
                                margin: EdgeInsets.fromLTRB(15, 10, 5, 10) ,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text("Red LED",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 15),
                                    Icon(Icons.lightbulb, size: 50, ),
                                    SizedBox(height: 15),
                                    Text("${redLightsOn}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.blue,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10) ,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text("Blue LED",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 15),
                                    Icon(Icons.lightbulb, size: 50),
                                    SizedBox(height: 15),
                                    Text("${blueLightsOn}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.lightBlueAccent,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10) ,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text("Water Pump",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 15),
                                    Icon(Icons.water_rounded, size: 50),
                                    SizedBox(height: 15),
                                    Text("${pumpOn}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.blueGrey,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 15) ,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text("Fan",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 15),
                                    Icon(Icons.flip_camera_android_sharp, size: 50),
                                    SizedBox(height: 15),
                                    Text("${fanOn}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ],
                                ),
                              ),
                            ]
                        ),

                        SizedBox(
                          height: 30,
                        ),



                      ]
                  ),
                );
              }
            }
        )
    );
  }
}