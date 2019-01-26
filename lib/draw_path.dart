import 'package:flutter/widgets.dart' as sky;
import 'package:flutter/painting.dart' as sky;
import 'package:flutter/rendering.dart' as sky;
import 'dart:ui' as skyui;

void main() {
  sky.runApp(new DemoWidget());
}

class DemoWidget extends sky.SingleChildRenderObjectWidget {
  @override
  sky.RenderObject createRenderObject(sky.BuildContext context) {
    return new DemoObject();
  }
}

class DemoObject extends sky.RenderConstrainedBox {
  DemoObject() : super(additionalConstraints: const sky.BoxConstraints.expand()) {
    ;
  }

  @override
  bool hitTestSelf(sky.Offset position) => true;

  @override
  void handleEvent(sky.PointerEvent event, sky.BoxHitTestEntry entry) {}

  @override
  void paint(sky.PaintingContext context, sky.Offset offset) {
    context.canvas.scale(2.5, 2.5);
    context.canvas.translate(10.0, 10.0);
    paintWithStroke(context);
    context.canvas.translate(50.0, 0.0);
    paintWithLinearGradient(context);

    //
    //
    // ng case
        {
      context.canvas.translate(0.0, 50.0);
      clip(context);
      paintWithLinearGradient(context);
    }
  }

  void paintWithStroke(sky.PaintingContext context) {
    sky.Paint p = new sky.Paint();
    p.strokeWidth = 2.0;
    p.style = skyui.PaintingStyle.stroke;
    sky.Path path = new sky.Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(10.0, 50.0);
    path.lineTo(50.0, 60.0);
    path.lineTo(40.0, 10.0);
    path.close();
    p.color = new sky.Color.fromARGB(0xaa, 0xaa, 0xff, 0xff);
    context.canvas.drawPath(path, p);
  }

  void paintWithLinearGradient(sky.PaintingContext context) {
    sky.Paint p = new sky.Paint();
    p.style = skyui.PaintingStyle.fill;//sky.PaintingStyle.stroke
    p.shader = new skyui.Gradient.linear(
        new skyui.Offset(0.0, 0.0), new skyui.Offset(50.0, 60.0),
        [const sky.Color.fromARGB(0xaa, 0xff, 0x00, 0x00), const sky.Color.fromARGB(0xaa, 0x00, 0x00, 0x00), const sky.Color.fromARGB(0xaa, 0x00, 0x00, 0xff),],
        [0.0, 0.5, 1.0],
        skyui.TileMode.clamp);

    sky.Path path = new sky.Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(10.0, 50.0);
    path.lineTo(50.0, 60.0);
    path.lineTo(40.0, 10.0);

    path.moveTo(10.0, 10.0);
    path.lineTo(30.0, 20.0);
    path.lineTo(40.0, 50.0);
    path.lineTo(20.0, 40.0);
    path.close();
    context.canvas.drawPath(path, p);
  }

  void clip(sky.PaintingContext context) {
    sky.Path path = new sky.Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(0.0, 25.0);
    path.lineTo(25.0, 25.0);
    path.lineTo(25.0, 0.0);
    path.close();
    context.canvas.clipPath(path);
//    context.canvas.clipRect(new Rect.fromLTWH(10.0, 10.0, 10.0, 10.0));
  }
}