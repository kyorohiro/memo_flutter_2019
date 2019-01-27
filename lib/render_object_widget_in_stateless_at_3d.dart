import 'package:flutter/material.dart' as ma;

import 'package:flutter/material.dart' as sky;
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter/rendering.dart' as sky;
import 'package:vector_math/vector_math_64.dart' as vec;
import 'dart:async';

main() async{
  await new Future.delayed(Duration(seconds: 2));
  ma.runApp(MyApp());
}
class MyApp extends ma.StatelessWidget {
  // This widget is the root of your application.
  @override
  ma.Widget build(ma.BuildContext context) {
    return ma.MaterialApp(
      title: 'Flutter Demo',
      theme: ma.ThemeData(
        primarySwatch: ma.Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends ma.StatelessWidget {

  @override
  ma.Widget build(ma.BuildContext context) {
    return new ma.Scaffold(
      appBar: ma.AppBar(title: ma.Text("Hello")),
      body: createBody(context),
    );
  }

}


ma.Widget createBody(ma.BuildContext context) {
//  return  DrawRectWidget();
  return ma.Row(children: <ma.Widget>[
    ma.Text("Hello"),
    DrawRectWidget(),
    ma.Text("Render"),
  ],);
}


//
// Rect
//
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
    print(">>${ui.window.devicePixelRatio}");
    this.size = sky.Size(50,50);
  }

  @override
  void handleEvent(sky.PointerEvent event, sky.BoxHitTestEntry entry) {}

  void paint(sky.PaintingContext context, sky.Offset offset) {
    print("${offset} ${this.size}");
    sky.Paint p = new sky.Paint();
    context.canvas.transform(vec.Matrix4.translation(vec.Vector3(offset.dx,offset.dy, 1.0)).storage);
    p.color = new sky.Color.fromARGB(0xff, 0x55, 0x55, 0x55);
    sky.Rect r = new sky.Rect.fromLTWH(0.0, 0.0, 50.0, 50.0);
    context.canvas.drawRect(r, p);
    context.canvas.transform(vec.Matrix4.translation(vec.Vector3(-offset.dx,-offset.dy, 1.0)).storage);
  }
}

