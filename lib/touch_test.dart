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
  double x = 100.0;
  double y = 100.0;

  void paint(sky.PaintingContext context, sky.Offset offset) {
    sky.Paint p = new sky.Paint();
    p.color = new sky.Color.fromARGB(0xff, 0xff, 0xff, 0xff);
    sky.Rect r = new sky.Rect.fromLTWH(x - 50.0, y - 50.0, 100.0, 100.0);
    context.canvas.drawRect(r, p);
  }

  @override
  void handleEvent(sky.PointerEvent event, sky.HitTestEntry entry) {
    if (entry is sky.BoxHitTestEntry) {
      if (event is sky.PointerDownEvent) {
        x = entry.localPosition.dx;
        y = entry.localPosition.dy;
      } else {
        x = event.position.dx;
        y = event.position.dy;
      }
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(sky.HitTestResult result, {sky.Offset position}) {
    result.add(new sky.BoxHitTestEntry(this, position));
    return true;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }
}
