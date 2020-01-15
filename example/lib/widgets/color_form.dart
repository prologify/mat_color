import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

const _key = '_main_color';

class ColorForm extends StatefulWidget {
  final onChange;

  ColorForm({Key key, @required this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ColorFormState();
}

class _ColorFormState extends State<ColorForm> {
  double _redSliderValue = 0.0;
  double _greenSliderValue = 0.0;
  double _blueSliderValue = 0.0;

  SharedPreferences _prefs;

  BehaviorSubject<Color> _controller = BehaviorSubject<Color>();

  @override
  initState() {
    _controller.debounceTime(Duration(milliseconds: 300)).listen((color) {
      widget.onChange(color);
    });

    _initStorage();

    super.initState();
  }

  _initStorage() async {
    _prefs = await SharedPreferences.getInstance();
    Color color;
    try {
      color = hexToColor(_prefs.getString(_key));
    } catch (e) {
      color = hexToColor('#000000');
    }

    _controller.add(color);

    setState(() {
      _redSliderValue = color.red.toDouble();
      _greenSliderValue = color.green.toDouble();
      _blueSliderValue = color.blue.toDouble();
    });
  }

  _addColor() {
    final color = Color.fromARGB(
      255,
      _redSliderValue.toInt(),
      _greenSliderValue.toInt(),
      _blueSliderValue.toInt(),
    );

    _controller.add(color);

    _prefs.setString(_key, colorToHex(color));
  }

  @override
  void dispose() {
    _controller.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 23.0),
              child: Container(
                width: 30.0,
                child: Text(
                  _redSliderValue.toInt().toString(),
                ),
              ),
            ),
            Flexible(
              child: Slider(
                min: 0,
                max: 255,
                onChanged: (value) => setState(() {
                  _redSliderValue = value.floor().toDouble();

                  _addColor();
                }),
                value: _redSliderValue,
                activeColor: Colors.red,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 23.0),
              child: Container(
                width: 30.0,
                child: Text(
                  _greenSliderValue.toInt().toString(),
                ),
              ),
            ),
            Flexible(
              child: Slider(
                min: 0,
                max: 255,
                onChanged: (value) => setState(() {
                  _greenSliderValue = value.floor().toDouble();
                  _addColor();
                }),
                value: _greenSliderValue,
                activeColor: Colors.green,
                label: '12',
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 23.0),
              child: Container(
                width: 30.0,
                child: Text(
                  _blueSliderValue.toInt().toString(),
                ),
              ),
            ),
            Flexible(
              child: Slider(
                min: 0,
                max: 255,
                onChanged: (value) => setState(() {
                  _blueSliderValue = value.floor().toDouble();
                  _addColor();
                }),
                value: _blueSliderValue,
                activeColor: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
