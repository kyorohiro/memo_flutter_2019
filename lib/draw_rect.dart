import 'package:flutter/material.dart' as sky;
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter/painting.dart' as sky;
import 'package:flutter/rendering.dart' as sky;

void main() {
  sky.runApp(new DrawRectWidget());
}

class DrawRectWidget extends sky.SingleChildRenderObjectWidget {
  sky.RenderObject createRenderObject(sky.BuildContext context){
    return new DrawRectObject();
  }
}

class DrawRectObject extends sky.RenderBox {

  @override
  bool hitTestSelf(sky.Offset position) => true;

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  void handleEvent(sky.PointerEvent event, sky.BoxHitTestEntry entry) {}

  void paint(sky.PaintingContext context, sky.Offset offset) {
    sky.Paint p = new sky.Paint();
    p.color = new sky.Color.fromARGB(0xff, 0x55, 0x55, 0x55);
    sky.Rect r = new sky.Rect.fromLTWH(50.0, 100.0, 150.0, 25.0);
    context.canvas.drawRect(r, p);
  }
}