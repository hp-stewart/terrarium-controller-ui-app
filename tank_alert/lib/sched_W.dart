import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Sched_W extends StatefulWidget {
  @override
  _Sched_WState createState() => _Sched_WState();
}

class _Sched_WState extends State<Sched_W> {
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
  List<dynamic> schedule = [];
  var numberOfItems = 0;
  var lastScanTime = "---";
  //functions

  getlastScanTime() async {
    print("fetching last scan time from firebase");
    final snapshot = await databaseRef.child("current status").child("time").get();
    if (snapshot.value != null) {
      print("fetched time: ${snapshot.value} degrees C");
      return await snapshot.value;
    } else {print("failed to read last scan time from firebase");}
  }
  getBLSchedule() async {

    List<dynamic> sched = [];
    print("fetching water pump schedule from firebase");
    for (var i = 00; i<24; i++) {
      final snapshot = await databaseRef.child("schedule").child("pump").child("${i}").get();
      if (snapshot.value != null) {
        print("fetched schedule: ${i}H = ${snapshot.value} ");
        sched.add(snapshot.value);
      } else {print("failed to read schedule from firebase");}
    }
    return sched;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule - Water Pump"),
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
                                child: Text("Return Home", style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
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
                                  child: Text("Other Schedules", style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/schedule');
                                }

                            ),

                          ]
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
                              child: Text("Load Schedule", style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            onPressed: ()  async {
                              schedule = await getBLSchedule();
                              numberOfItems = schedule.length;
                              lastScanTime = await getlastScanTime();
                              setState(() {
                              });
                            }

                        ),
                      ),
                      Text(
                        "24h Hour Schedule: ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      ListView.builder(
                        itemCount: numberOfItems,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children:[
                                  Text("${index.toString().padLeft(2,'0')}"),
                                  Text("State: ${schedule[index]}"),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black12,
                                    ),
                                    child: Text("Toggle State"),
                                    onPressed: () async {
                                      var newState;
                                      if (schedule[index] == 1) {newState = 0;} else {newState = 1;}
                                      print("preparing to toggle hour ${index.toString().padLeft(2,'0')} to state ${newState} in firebase");
                                      await databaseRef.child("schedule").child("pump").child("${index}").set(newState);
                                      schedule = await getBLSchedule();
                                      numberOfItems = schedule.length;
                                      setState(() {

                                      });
                                    },
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
