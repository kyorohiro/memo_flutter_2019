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

class TouchInfo {
  double x = 0.0;
  double y = 0.0;
  double pressure = 0.0;
  bool isTouch = false;
}

class DrawRectObject extends sky.RenderBox {
  Map<int, TouchInfo> touchInfos = {};
  double x = 100.0;
  double y = 100.0;

  void paint(sky.PaintingContext context, sky.Offset offset) {
    sky.Paint p = new sky.Paint();
    for (TouchInfo t in touchInfos.values) {
      if (t.isTouch) {
        p.color = new sky.Color.fromARGB(0xff, 0xff, 0xff, 0xff);
        double size = 100 * t.pressure;
        sky.Rect r = new sky.Rect.fromLTWH(t.x - size / 2, t.y - size / 2, size, size);
        context.canvas.drawRect(r, p);
      }
    }
  }

  @override
  void handleEvent(sky.PointerEvent event, sky.HitTestEntry entry) {
    if (!attached) {
      return;
    }
    if (entry is sky.BoxHitTestEntry) {
      if(event is sky.PointerDownEvent) {
        touchInfos[event.pointer] = new TouchInfo();
        touchInfos[event.pointer].x = entry.localPosition.dx;
        touchInfos[event.pointer].y = entry.localPosition.dy;
        touchInfos[event.pointer].pressure = event.pressure / event.pressureMax;
        touchInfos[event.pointer].isTouch = true;
      } else if(event is sky.PointerMoveEvent) {
        touchInfos[event.pointer].x = event.position.dx;
        touchInfos[event.pointer].y = event.position.dy;
        touchInfos[event.pointer].pressure = event.pressure / event.pressureMax;
      } else if(event is sky.PointerUpEvent) {
        touchInfos[event.pointer].x = event.position.dx;
        touchInfos[event.pointer].y = event.position.dy;
        touchInfos[event.pointer].isTouch = false;
      } else if(event is sky.PointerCancelEvent) {
        print("pointer cancel");
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
