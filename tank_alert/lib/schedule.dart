import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tank_alert/sched_RL.dart';


class Schedule extends StatelessWidget {
  final databaseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Return to Home", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                onPressed: ()  {
                  Navigator.pop(context);
                }
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/schedRL');},
                  color: Colors.red,
                  padding: EdgeInsets.fromLTRB(80,80,80,80),
                  child: Column( // Replace with a Row for horizontal icon + text
                    children: [
                      Icon(Icons.lightbulb, size: 50),
                      SizedBox(height: 10),
                      Text("Red LED",
                        style: TextStyle(
                          fontSize: 20,
                        ),)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 10, 20, 10),
                child: FlatButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/schedBL')
                    },
                  color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(80,80,80,80),
                  child: Column( // Replace with a Row for horizontal icon + text
                    children: [
                      Icon(Icons.lightbulb, size: 50),
                      SizedBox(height: 10),
                      Text("Blue LED",
                        style: TextStyle(
                          fontSize: 20,
                        ),)
                    ],
                  ),
                ),
              ),

            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
                child: FlatButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/schedW')},
                  padding: EdgeInsets.fromLTRB(80,80,80,80),
                  color: Colors.lightBlueAccent,
                  child: Column( // Replace with a Row for horizontal icon + text
                    children: [
                      Icon(Icons.water, size: 50),
                      SizedBox(height: 10),
                      Text("   Pump  ",
                        style: TextStyle(
                          fontSize: 20,
                        ),)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 10, 20, 10),
                child: FlatButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/schedF')},
                  color: Colors.blueGrey,
                  padding: EdgeInsets.fromLTRB(80,80,80,80),
                  child: Column( // Replace with a Row for horizontal icon + text
                    children: [
                      Icon(Icons.flip_camera_android_sharp, size: 50),
                      SizedBox(height: 10),
                      Text("     Fan     ",
                        style: TextStyle(
                          fontSize: 20,
                        ),)
                    ],
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
