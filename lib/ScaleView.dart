import 'package:flutter/material.dart';

class ScaleView extends StatefulWidget {
  const ScaleView({
    super.key,
    this.viewWidth = 500,
    this.viewHeight = 500,
    required this.items,
  });
  final double viewWidth;
  final double viewHeight;
  final List<Widget> items;

  @override
  State<ScaleView> createState() => _ScaleViewState();
}

class _ScaleViewState extends State<ScaleView> {
  double _pageValue = 0.0;
  final PageController _controller = PageController(viewportFraction: 0.85);
  final _scaleFactor = 0.9;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _pageValue = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.viewWidth / 0.85,
      height: widget.viewHeight,
      child: PageView.builder(
        controller: _controller,
        itemBuilder: (context, index) {
          int curPage = _pageValue.floor();
          double offset = _pageValue - index;
          double delta = 1 - _scaleFactor;
          Matrix4 matrix = Matrix4.identity();
          if (offset.abs() <= 0.5) {
            double scaleValue = 1 - offset.abs() * 2 * delta;
            double transValueX = widget.viewWidth * (1 - scaleValue) / 2;
            double transValueY = widget.viewHeight * (1 - scaleValue) / 2;
            matrix.scale(scaleValue, scaleValue, 1);
            matrix.translate(transValueX, transValueY, 0);
          } else {
            double scaleValue = _scaleFactor;
            double transValueX = widget.viewWidth * (1 - scaleValue) / 2;
            double transValueY = widget.viewHeight * (1 - scaleValue) / 2;
            matrix.scale(scaleValue, scaleValue, 1);
            matrix.translate(transValueX, transValueY, 0);
          }
          return Transform(transform: matrix, child: widget.items[index]);
        },
        itemCount: widget.items.length,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
