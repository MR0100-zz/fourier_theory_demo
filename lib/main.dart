import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  return runApp(MyApp());
}

Queue waveX = Queue();
Queue waveY = Queue();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double time = 0;

  draw() async {
    for (;;) {
      await Future.delayed(Duration(milliseconds: 1));
      setState(() {
        time = time - 0.01;
      });
    }
  }

  @override
  void initState() {
    draw();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: CustomPaint(
            painter: CustomPainterClass(time),
          ),
        ),
      ),
    );
  }
}

class CustomPainterClass extends CustomPainter {
  final double time;

  CustomPainterClass(this.time);
  @override
  void paint(Canvas canvas, Size size) {
    double x = 1;
    double y = 1;
    for (int k = 0; k < 10; k++) {
      int n = (k * 2) + 1;
      double anRadius = 20 * (4 / (n * (pi)));
      // double anRadius = 20;
      double prevX = x;
      double prevY = y;

      x += anRadius * cos(n * time * n);
      y += anRadius * sin(n * time);

      // x += anRadius * cos(((2 * pi) / 8) * n) / (time / pi); 
      // y += anRadius * sin(((2 * pi) / 8) * n) / (time / pi);
      canvas.drawCircle(
          Offset(x, y),
          1,
          Paint()
            ..color = Colors.black
            ..strokeWidth = 1
            ..style = PaintingStyle.fill);
      canvas.drawCircle(
          Offset(prevX, prevY),
          anRadius,
          Paint()
            ..color = Colors.black.withOpacity(0.1)
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke);

      canvas.drawLine(
          Offset(prevX, prevY),
          Offset(x, y),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke);
    }
    waveY.addFirst(y);
    waveX.addFirst(x);

    // canvas.drawLine(
    //     Offset(x, y),
    //     Offset(100, waveY.elementAt(0)),
    //     Paint()
    //       ..color = Colors.black
    //       ..strokeWidth = 1
    //       ..style = PaintingStyle.stroke);

    for (double i = 100; i < (waveY.length + 100); i++) {
      canvas.drawCircle(
          Offset(waveX.elementAt((i - 100).toInt()),
              waveY.elementAt((i - 100).toInt())),
          0.5,
          Paint()
            ..color = Colors.black
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke);
    }

    if (waveY.length >= 2000) {
      waveY.removeLast();
    }
    if (waveX.length >= 2000) {
      waveX.removeLast();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
