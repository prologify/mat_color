import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mat_color/mat_color.dart';

import 'widgets/color_container.dart';
import 'widgets/widget.dart';

final colorKeys = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark();

    return MaterialApp(
      title: 'MatColor',
      theme: darkTheme.copyWith(
        textTheme: darkTheme.textTheme.apply(fontFamily: 'RobotoMono'),
        accentTextTheme:
            darkTheme.accentTextTheme.apply(fontFamily: 'RobotoMono'),
        primaryTextTheme:
            darkTheme.primaryTextTheme.apply(fontFamily: 'RobotoMono'),
        snackBarTheme: darkTheme.snackBarTheme.copyWith(
          contentTextStyle: darkTheme.textTheme.body2
              .copyWith(color: Colors.black87)
              .apply(fontFamily: 'RobotoMono'),
        ),
      ),
      home: MyHomePage(title: 'MatColor'),
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
  Color _mainColor;
  Map<String, ThemeColor> palette;

  set mainColor(Color color) {
    _mainColor = color;
    palette = theme({'accent': _mainColor});

    final defaultKey = palette['accent'].primaryIndex;
    final mainTextColor = palette['accent'].contrasts[defaultKey];

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness:
            mainTextColor == Colors.black ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  void initState() {
    onChangeColor(Colors.black);
    super.initState();
  }

  onChangeColor(Color color) {
    setState(() {
      mainColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultKey = palette['accent'].primaryIndex;
    final mainTextColor = palette['accent'].contrasts[defaultKey];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          var aspectRatio;
          if (constraints.maxWidth <= 640) {
            aspectRatio = 5 / 4;
          } else {
            aspectRatio = 3 / 1;
          }

          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 640.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: aspectRatio,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                color: _mainColor,
                              ),
                            ),
                            Positioned(
                              bottom: 24.0,
                              left: 24.0,
                              child: Logo(
                                color: mainTextColor,
                                width: 100.0,
                              ),
                            ),
                          ],
                        ),
                        ColorForm(
                          onChange: onChangeColor,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: colorKeys.map((int key) {
                        final Color color = palette['accent'][key];
                        final Color textColor =
                            palette['accent'].contrasts[key];

                        return GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                  text:
                                      '#${color.red.toRadixString(16)}${color.green.toRadixString(16)}${color.blue.toRadixString(16)}'),
                            );

                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Copy to clipboard!'),
                            ));
                          },
                          child: ColorContainer(
                            duration: Duration(milliseconds: 300),
                            color: color,
                            builder: (context, Color color) {
                              return Card(
                                shape: defaultKey == key
                                    ? RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(31.0),
                                      )
                                    : null,
                                color: color,
                                margin: EdgeInsets.zero,
                                child: Container(
                                  key: Key(key.toString()),
                                  width: 64.0,
                                  height: 64.0,
                                  child: Center(
                                    child: Text(
                                      key.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
