import 'package:flutter/material.dart';
import 'dart:math';

typedef void StepTapCallback(int step);

class SteppingBar extends StatelessWidget {
  final double width, height, separation, slack;
  final int stepsNumber, currentStep;
  final Color darkColor;
  final Color lightColor;
  final Color currentStepColor;
  final double skew;
  final StepTapCallback onStepTap;

  SteppingBar({
    this.width = 70.0,
    this.height = 30.0,
    this.separation = 10.0,
    double slack,
    this.skew = 0.0,
    this.stepsNumber = 2,
    this.currentStep = 1,
    this.darkColor = Colors.blue,
    Color lightColor,
    Color currentStepColor,
    this.onStepTap,
  })  : lightColor = lightColor ?? Colors.blue[100],
        currentStepColor = currentStepColor ?? darkColor,
        slack = slack ?? height / 2 {
    if (stepsNumber < 1) {
      throw Exception(
        'Current step ($stepsNumber) should be least or equal to 1',
      );
    }

    if (currentStep < 0) {
      throw Exception(
        'Current step ($currentStep) should be positive or zero',
      );
    }

    if (currentStep >= stepsNumber) {
      throw Exception(
        'Current step ($currentStep) should be less than steps Number ($stepsNumber)',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget separator = SizedBox(width: separation);
    final steps = List<Widget>(2 * stepsNumber - 1);

    for (int i = 0; i < stepsNumber; i++) {
      if (i > 0) {
        steps[2 * i - 1] = separator;
      }
      steps[2 * i] = GestureDetector(
        onTap: () {
          if (onStepTap != null) onStepTap(i);
        },
        child: skewedStep(i),
      );
    }

    //return Row(children: steps);
    return ClipPath(
      clipBehavior: Clip.hardEdge,
      clipper: SteppingBarClipper(vsync: this),
      child: Row(children: steps),
    );
  }

  Widget skewedStep(int step) {
    final color = step > currentStep
        ? lightColor
        : step == currentStep ? currentStepColor : darkColor;

    double _width = width;
    if (step == 0) _width += slack;
    if (step == stepsNumber - 1) _width += slack;

    return Transform(
      transform: Matrix4.skewX(skew),
      child: Container(
        decoration: BoxDecoration(color: color),
        width: _width,
        height: height,
      ),
    );
  }
}

class SteppingBarClipper extends CustomClipper<Path> {
  final SteppingBar vsync;
  final int arcSteps;
  SteppingBarClipper({this.vsync, this.arcSteps = 20});

  @override
  Path getClip(Size size) {
    final radius = size.height / 2;
    final projection = tan(vsync.skew) * size.height;
    final points = List<Offset>(2 * arcSteps + 2);

    generateArc(
      radius: radius,
      xCenter: vsync.slack +
          vsync.width +
          projection / 2 -
          radius +
          (vsync.stepsNumber - 1) * (vsync.width + vsync.separation),
      yCenter: radius,
      startAngle: -pi / 2,
      endAngle: pi / 2,
      points: points,
      pointsOffset: 0,
      arcSteps: arcSteps,
    );
    generateArc(
      radius: radius,
      xCenter: vsync.slack + projection / 2 + radius,
      yCenter: radius,
      startAngle: pi / 2,
      endAngle: 3 * pi / 2,
      points: points,
      pointsOffset: arcSteps + 1,
      arcSteps: arcSteps,
    );

    return Path()..addPolygon(points, true);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static void generateArc({
    double radius,
    double xCenter,
    double yCenter,
    double startAngle,
    double endAngle,
    List<Offset> points,
    int pointsOffset,
    int arcSteps = 20,
  }) {
    for (int i = 0; i < arcSteps + 1; i++) {
      final theta = startAngle + (endAngle - startAngle) * i / arcSteps;
      double dx = xCenter + radius * cos(theta);
      double dy = yCenter + radius * sin(theta);
      points[pointsOffset + i] = Offset(dx, dy);
    }
  }
}
