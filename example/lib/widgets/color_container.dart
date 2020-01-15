import 'package:flutter/material.dart';

typedef ColorContainerBuilder = Widget Function(
    BuildContext context, Color color);

class ColorContainer extends StatefulWidget {
  final ColorContainerBuilder builder;
  final Color color;
  final Duration duration;

  ColorContainer({
    Key key,
    @required this.builder,
    @required this.color,
    @required this.duration,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ColorContainerState();
}

class _ColorContainerState extends State<ColorContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ColorTween _colorTween;
  Animation _colorAnimation;

  @override
  void initState() {
    _colorTween = ColorTween(begin: widget.color, end: widget.color);
    _animationController =
        AnimationController(vsync: this, duration: widget.duration, value: 0.0);
    _colorAnimation = _colorTween.animate(_animationController);


    super.initState();
  }

  @override
  void didUpdateWidget(ColorContainer oldWidget) {
    _colorTween.begin = oldWidget.color;
    _colorTween.end = widget.color;

    _animationController.forward(from: 0.0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return widget.builder(context, _colorAnimation.value);
      },
    );
  }
}
