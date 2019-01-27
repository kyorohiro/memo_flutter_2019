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
    sky.Color textColor = const sky.Color.fromARGB(0xaa, 0xff, 0xaa, 0xaa);
    sky.TextStyle textStyle = new sky.TextStyle(fontSize: 50.0, color: textColor);
    sky.TextSpan testStyledSpan = new sky.TextSpan(
        text:"Hello Text!! こんにちは!!",
        style:textStyle);
    sky.TextPainter textPainter = new sky.TextPainter(text:
    testStyledSpan,textDirection: sky.TextDirection.ltr);

    textPainter.layout(minWidth: 200.0, maxWidth: 200.0);
    textPainter.paint(context.canvas, new skyui.Offset(100.0, 100.0));
  }
}
