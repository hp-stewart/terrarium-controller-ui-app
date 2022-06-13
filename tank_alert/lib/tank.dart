import 'package:flutter/material.dart';

class Tank {

  DateTime scanTime = DateTime.utc(2000, 1, 1, 0, 0, 0);
  int light = 0;
  int temp = 0;
  int humidity = 0;
  int moisture = 0;

  int redLight = -1;
  int blueLight = -1;
  int waterPump = -1;
  int fan = -1;

  DateTime getScanTime() {return scanTime;}
  int getLight(){return light;}
  int getTemp(){return temp;}
  int getHumidity(){return humidity;}
  int getMoisture(){return moisture;}
  int getRedLightState(){return redLight;}
  int getBlueLightState(){return blueLight;}
  int getWaterPumpState(){return waterPump;}
  int getFanState(){return fan;}

  void setScanTime(DateTime t) {
    scanTime = t;
  }
  void setLight(int l) {
    light = l;
  }
  void setTemp (int t) {
    temp = t;
  }
  void setHumidity(int h) {
    humidity = h;
  }
  void setMoisture(int m) {
    moisture = m;
  }
  void setRedLighState(int r) {
    redLight = r;
  }
  void setBlueLightState(int b) {
    blueLight = b;
  }
  void setFanState(int f) {
    fan = f;
  }
  void setWaterPumpState(int w) {
    waterPump = w;
  }

  Tank(
      this.scanTime,
      this.light,
      this.temp,
      this.humidity,
      this.moisture,
      [
        this.redLight = -1,
        this.blueLight = -1,
        this.waterPump =-1,
        this.fan = -1 ]);
}