import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  int _counter = 0;
  bool handdown = true;
  bool handup = false;
  int time = 0;

  double test;

  double max = 0;
  double min = 0;

  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  void CounterNumber() {
    if(_accelerometerValues[0] >= 10){
      if(time == 0){
        if(handdown == true || handup == false) {
          handdown = false;
          handup = true;
        }
        else if(handdown == false || handup == true) {
          handdown = true;
          handup = false;
          setState(() {
            _counter++;
            Vibration.vibrate();
            // Max();
          });
        }
        time = 1;
      }
    }
    if(_accelerometerValues[0] < 10){
      time = 0;
    }
  }

  void reset() {
    setState(() {
      _counter = 0;
      handdown = true;
      handup = false;
      max = 0;
      min = 0;
    });
  }

  void Max() {
    if(max < test){
      max = double.parse(test.toStringAsFixed(2));
    }
    if(max != 0) {
      if(min == 0){
        min = max;
      }
      if(min > test) {
        min = double.parse(test.toStringAsFixed(2));
      }
    }
  }
  
  // void Min() {
  //   if(min > test){
  //     min = double.parse(test.toStringAsFixed(2));
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    CounterNumber();
    Max();

    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Counter: $_counter', style: TextStyle(fontSize: 20), ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
                // Text('Test: $test'),
                Text('Handdown: $handdown'),
                Text('Handup: $handup'),
                Text('Max: $max'),
                Text('Min: $min'),
                RaisedButton(
                  onPressed: reset,
                  child: Text('Reset'),
                )
              ],
            ),
            padding: const EdgeInsets.all(16.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent event) {
      test = event.y;
    });

    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // _accelerometerValues = <double>[event.x, event.y, event.z];
        _accelerometerValues = <double>[event.y];
      });
    }));
  }
}