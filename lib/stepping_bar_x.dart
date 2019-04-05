import 'package:flutter/material.dart';
import 'dart:math';

typedef void StepTapCallback(int step);

class SteppingBar extends StatelessWidget {
  final double width, height, between;
  final int stepsNumber, currentStep;
  final Color darkColor;
  final Color lightColor;
  final Color currentStepColor;
  final double skew;
  final StepTapCallback onStepTap;

  SteppingBar({
    this.width = 70.0,
    this.height = 30.0,
    this.between = 10.0,
    this.skew = 0.0,
    this.stepsNumber = 2,
    this.currentStep = 1,
    this.darkColor = Colors.blue,
    Color lightColor,
    Color currentStepColor,
    this.onStepTap,
  })  : lightColor = lightColor ?? Colors.blue[100],
        currentStepColor = currentStepColor ?? darkColor {
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
    final Widget space = SizedBox(width: between);
    List<Widget> steps = List(2 * stepsNumber - 1);

    for (int i = 0; i < stepsNumber; i++) {
      if (i > 0) {
        steps[2 * i - 1] = space;
      }
      steps[2 * i] = GestureDetector(
        onTap: () {
          if (onStepTap == null) return;
          onStepTap(i);
        },
        child: skewedStep(i),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: steps,
    );
  }

  Widget skewedStep(int step) {
    final color = step > currentStep
        ? lightColor
        : step == currentStep ? currentStepColor : darkColor;
    final radius = Radius.circular(height / 2);

    if (stepsNumber == 1)
      return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.horizontal(right: radius, left: radius),
        ),
        width: width,
        height: height,
      );

    if (step == 0)
      return ClipPath(
        clipper: FirstStepClipper(skew: skew, width: width),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            //borderRadius: BorderRadius.horizontal(left: radius),
          ),
          width: 1.2 * width,
          height: height,
        ),
      );

    if (step == stepsNumber - 1)
      return ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: LastStepClipper(skew: skew, width: width),
        child: Transform(
          transform: Matrix4.skewX(skew),
          child: Container(
            decoration: BoxDecoration(color: color),
            width: 1.2 * width,
            height: height,
          ),
        ),
        //child: Container(
        //  decoration: BoxDecoration(
        //    color: color,
        //    borderRadius: BorderRadius.horizontal(right: radius),
        //  ),
        //  width: width,
        //  height: height,
        //),
      );

    return Transform(
      transform: Matrix4.skewX(skew),
      child: Container(
        decoration: BoxDecoration(color: color),
        width: width,
        height: height,
      ),
    );
  }
}

class FirstStepClipper extends CustomClipper<Path> {
  final double skew;
  final double width;
  final int circlePointsNumber;
  FirstStepClipper({
    this.skew,
    this.width,
    this.circlePointsNumber = 20,
  }) : assert(skew != null);

  @override
  Path getClip(Size size) {
    final radius = size.height / 2;
    final projection = tan(skew) * size.height;
    final points = List<Offset>(circlePointsNumber + 3);

    points[0] = Offset(size.width, 0);
    for (int i = 1; i < circlePointsNumber + 2; i++) {
      double theta = i * pi / circlePointsNumber;
      double x =
          size.width - width + projection / 2 + radius - radius * sin(theta);
      double y = radius - radius * cos(theta);
      points[i] = Offset(x, y);
    }
    points[circlePointsNumber + 2] =
        Offset(size.width + projection, size.height);

    return Path()..addPolygon(points, true);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LastStepClipper extends CustomClipper<Path> {
  final double skew;
  final double width;
  final int circlePointsNumber;
  LastStepClipper({
    this.skew,
    this.width,
    this.circlePointsNumber = 20,
  }) : assert(skew != null);

  @override
  Path getClip(Size size) {
    final radius = size.height / 2;
    final projection = tan(skew) * size.height;
    final points = List<Offset>(circlePointsNumber + 3);

    points[0] = Offset(0, 0);
    points[1] = Offset(width, 0);
    for (int i = 2; i < circlePointsNumber + 2; i++) {
      double theta = (i - 1) * pi / circlePointsNumber;
      double x = width + projection / 2 - radius + radius * sin(theta);
      double y = radius - radius * cos(theta);
      points[i] = Offset(x, y);
    }
    points[circlePointsNumber + 2] = Offset(projection, size.height);

    return Path()..addPolygon(points, false);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
