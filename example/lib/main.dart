import 'package:flutter/material.dart';
import 'package:stepping_bar/stepping_bar.dart';

void main() => runApp(SteppingBarDemo());

class SteppingBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stepping Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stepping Bar Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final steps = 4;
  final width = 65.0;
  final height = 20.0;
  final between = 5.0;
  final skew = -0.5;
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentStep = 0;

  _nextStep() {
    setState(() {
      if (currentStep < widget.steps - 1) currentStep++;
    });
  }

  _previousStep() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('stepping bar Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Step: ${currentStep + 1}',
            style: Theme.of(context).textTheme.display1,
          ),
          SteppingBar(
            width: widget.width,
            height: widget.height,
            separation: widget.between,
            skew: widget.skew,
            currentStep: currentStep,
            stepsNumber: widget.steps,
          ),
          SizedBox(height: 5.0),
          SteppingBar(
            width: widget.width,
            height: widget.height,
            separation: widget.between,
            skew: widget.skew,
            currentStep: currentStep,
            stepsNumber: widget.steps,
            darkColor: Colors.pink,
            lightColor: Colors.pink[100],
          ),
          SizedBox(height: 5.0),
          SteppingBar(
            width: widget.width,
            height: widget.height,
            separation: widget.between,
            skew: widget.skew,
            currentStep: currentStep,
            stepsNumber: widget.steps,
            darkColor: Colors.pink,
            lightColor: Colors.pink[100],
            currentStepColor: Colors.pink[800],
          ),
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: widget.height,
                width: 10.0,
              ),
              SteppingBar(
                width: widget.width,
                height: widget.height,
                separation: widget.between,
                skew: -widget.skew,
                currentStep: currentStep,
                stepsNumber: widget.steps,
                darkColor: Colors.pink,
                lightColor: Colors.pink[100],
                currentStepColor: Colors.pink[800],
              ),
              Container(
                color: Colors.black,
                height: widget.height,
                width: 10.0,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: fab(),
    );
  }

  Widget fab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _nextStep,
          tooltip: 'Next Step',
          child: Icon(Icons.arrow_drop_up),
        ),
        SizedBox(height: 5.0),
        FloatingActionButton(
          onPressed: _previousStep,
          tooltip: 'Previous Step',
          child: Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
