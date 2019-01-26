import 'package:flutter/material.dart' as sky;
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter/painting.dart' as sky;
import 'package:flutter/rendering.dart' as sky;
import 'dart:async';
import 'dart:math';

void main() {
  sky.runApp(DrawRectWidget()..anime());
}

class DrawRectWidget extends sky.SingleChildRenderObjectWidget {
  final DrawRectObject drawObj = new DrawRectObject();

  @override
  sky.RenderObject createRenderObject(sky.BuildContext context){
    return drawObj;
  }

  Future anime() async {
    double angle = 0.0;
    while (true) {
      await new Future.delayed(new Duration(milliseconds: 20));
      drawObj.x = 150 * cos(pi * angle / 180.0) + 100.0;
      drawObj.y = 150 * sin(pi * angle / 180.0) + 100.0;
      angle++;
      drawObj.markNeedsPaint();
    }
  }
}

class DrawRectObject extends sky.RenderBox {
  double x = 50.0;
  double y = 50.0;
  void paint(sky.PaintingContext context, sky.Offset offset) {
    sky.Paint p = new sky.Paint();
    p.color = new sky.Color.fromARGB(0xff, 0xff, 0xff, 0xff);
    sky.Rect r = new sky.Rect.fromLTWH(x, y, 25.0, 25.0);
    context.canvas.drawRect(r, p);
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  bool hitTest(sky.HitTestResult result, {sky.Offset position}) {
    result.add(new sky.BoxHitTestEntry(this, position));
    return true;
  }
}
