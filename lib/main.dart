import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter/material.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:the_vote/thevote.dart';
import 'package:the_vote/RandomSingle.dart';
import 'package:the_vote/Groupb.dart';
import 'dart:ui' as ui;
import 'listitem.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'database_helper.dart';
import 'package:provider/provider.dart';
import 'package:the_vote/store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Store();
        }),
        ChangeNotifierProvider(create: (context) {
          return Votestore();
        })
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/Mainpags': (context) => Mainpags(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/RandomSingle': (context) => RandomSingle(),
          '/Groupb': (context) => Groupb(),
          '/ThevotePage': (context) => ThevotePage(),
        },
        debugShowCheckedModeBanner: false,
        title: 'The vote',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Heebo'),
        home: Mainpags(),
      ),
    );
  }
}

class Mainpags extends StatefulWidget {
  @override
  _MainpagsState createState() => _MainpagsState();
}

class _MainpagsState extends State<Mainpags> {
  final double _borderRadius = 24;
  void test(r) {
    if (r == 'Random')
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RandomSingle()));
    else if (r == 'GroupRandom')
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Groupb()));
    else if (r == 'Thevote')
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ThevotePage()));
  }

  imgFunction(c) {
    if (c == 'Random')
      return Image.asset(
        'assets/img/dice.png',
        height: 64,
        width: 64,
      );
    else if (c == 'GroupRandom')
      return Image.asset(
        'assets/img/kanban.png',
        height: 64,
        width: 64,
      );
    else if (c == 'Thevote')
      return Image.asset(
        'assets/img/poll.png',
        height: 64,
        width: 64,
      );
  }

  var items = [
    PlaceInfo(
        'Random Single Mode',
        Color(0xff6DC8F3),
        Color(0xff73A1F9),
        1,
        'You can create your own challenge or make your decision with yourself',
        '___________________________________',
        'Random'),
    PlaceInfo(
        'Random Group',
        Color(0xffFFB157),
        Color(0xffFFA057),
        2,
        'You can mange you group random with yourself in this function',
        '___________________________________',
        'GroupRandom'),
    PlaceInfo(
        'The Vote',
        Color(0xffD76EF5),
        Color(0xff8F7AFE),
        3,
        'You can not make decision with you friend So,let the vote help you:)',
        '___________________________________',
        'Thevote'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Select Mode',
            style: TextStyle(
                fontFamily: 'Lobster', fontSize: 20, color: Color(0xFF545D68)),
          ),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                test(items[index].route);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            gradient: LinearGradient(
                                colors: [
                                  items[index].startColor,
                                  items[index].endColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: [
                              BoxShadow(
                                  color: items[index].endColor,
                                  blurRadius: 3,
                                  offset: Offset(0, 2))
                            ]),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: CustomPaint(
                          size: Size(100, 160),
                          painter: CustomCardShapePainter(_borderRadius,
                              items[index].startColor, items[index].endColor),
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: imgFunction(items[index].route),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    items[index].name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    items[index].category,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Flexible(
                                    child: Text(
                                      items[index].location,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    items[index].rating.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlaceInfo {
  final String name;
  final String category;
  final String location;
  final double rating;
  final Color startColor;
  final Color endColor;
  final String route;
  PlaceInfo(this.name, this.startColor, this.endColor, this.rating,
      this.location, this.category, this.route);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;
  CustomCardShapePainter(this.radius, this.startColor, this.endColor);
  @override
  void paint(Canvas canvas, Size size) {
    var radius = 3.0;
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(3, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - radius * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
