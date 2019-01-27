import 'package:flutter/material.dart' as ma;

import 'package:flutter/material.dart' as sky;
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter/painting.dart' as skyp;
import 'package:flutter/rendering.dart' as sky;
import 'package:vector_math/vector_math_64.dart' as vec;
import 'dart:ui' as ui;


//
import 'package:flutter/scheduler.dart' as sky;
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' as skys;

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
    DrawRectWidget(),
    ma.Text("Hello"),
    DrawVertexsWidget(),
    ma.Text("Render"),
    DrawRectWidget(),
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
   // print(">>${ui.window.devicePixelRatio}");
    this.size = sky.Size(50,50);
//        50.0/sky.window.devicePixelRatio,50.0/sky.window.devicePixelRatio);
  }

  @override
  void handleEvent(sky.PointerEvent event, sky.BoxHitTestEntry entry) {}

  void paint(sky.PaintingContext context, sky.Offset offset) {
    //this.size = sky.Size(10,10);
    print("${offset} ${this.size}");
    sky.Paint p = new sky.Paint();
    context.canvas.transform(vec.Matrix4.translation(vec.Vector3(offset.dx,offset.dy, 1.0)).storage);
    p.color = new sky.Color.fromARGB(0xff, 0x55, 0x55, 0x55);
    sky.Rect r = new sky.Rect.fromLTWH(0.0, 0.0, 50.0, 50.0);
    context.canvas.drawRect(r, p);
    context.canvas.transform(vec.Matrix4.translation(vec.Vector3(-offset.dx,-offset.dy, 1.0)).storage);
  }
}


//
// 3D
//



class DrawVertexsWidget extends sky.SingleChildRenderObjectWidget {
  @override
  sky.RenderObject createRenderObject(sky.BuildContext context) {
    return new DrawVertexsObject()..anime();
  }
}

class DrawVertexsObject extends sky.RenderBox {
  ui.Image img = null;
  double angle = 0.0;
  DrawVertexsObject() {
    loadImage();
  }

  void anime() {
    sky.SchedulerBinding.instance.scheduleFrameCallback((Duration timeStamp) {
      angle += math.pi / 90.0;
      this.markNeedsPaint();
      anime();
    });
  }

  loadImage() async {
    if (img == null) {
      img = await ImageLoader.load("assets/sample.jpeg");
      this.markNeedsPaint();
    }
  }

  @override
  bool hitTestSelf(sky.Offset position) => true;

  @override
  void performLayout() {
    print(">>${ui.window.devicePixelRatio}");
    this.size = sky.Size(50,50);
//        50.0/sky.window.devicePixelRatio,50.0/sky.window.devicePixelRatio);
  }

  @override
  void handleEvent(sky.PointerEvent event, sky.BoxHitTestEntry entry) {}

  @override
  void paint(sky.PaintingContext context, sky.Offset offset) {
    //print("${offset}");
    if(img == null) {
      return;
    }

    context.canvas.translate(offset.dx, offset.dy);
    vec.Matrix4 mat = new vec.Matrix4.identity();
    mat.rotateY(math.pi / 2.0 + angle);
    mat.rotateX(angle);
    drawSurface(context, offset, mat);
    mat.rotateY(math.pi / 2.0);
    drawSurface(context, offset, mat);
    mat.rotateY(math.pi / 2.0);
    drawSurface(context, offset, mat);
    mat.rotateY(math.pi / 2.0);
    drawSurface(context, offset, mat);
    mat.rotateX(math.pi / 2.0);
    drawSurface(context, offset, mat);
    mat.rotateX(math.pi / 1.0);
    drawSurface(context, offset, mat);
    context.canvas.translate(-offset.dx, -offset.dy);

  }

  void drawSurface(sky.PaintingContext context, sky.Offset offset, vec.Matrix4 mat) {
    sky.Paint paint = new sky.Paint();
    sky.VertexMode vertexMode = sky.VertexMode.triangleFan;
    vec.Vector3 vec1 = mat * new vec.Vector3(-25.0, -25.0, -25.0);
    vec.Vector3 vec2 = mat * new vec.Vector3(-25.0, 25.0, -25.0);
    vec.Vector3 vec3 = mat * new vec.Vector3(25.0, 25.0, -25.0);
    vec.Vector3 vec4 = mat * new vec.Vector3(25.0, -25.0, -25.0);
    vec.Vector3 normal = (vec1 - vec2).cross(vec1 - vec3);
    if (normal.z < 0) {
      return;
    }
    List<sky.Offset> verticesSrc = [
      new sky.Offset(vec1.x, vec1.y),
      new sky.Offset(vec2.x, vec2.y),
      new sky.Offset(vec3.x, vec3.y),
      new sky.Offset(vec4.x, vec4.y)
    ];
    List<sky.Offset> textureCoordinates = [
      new sky.Offset(0.0, 0.0),
      new sky.Offset(0.0, 1.0 * img.height),
      new sky.Offset(1.0 * img.width, 1.0 * img.height),
      new sky.Offset(1.0 * img.width, 0.0)
    ];
    List<sky.Color> colors = [
      const sky.Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
      const sky.Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
      const sky.Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
      const sky.Color.fromARGB(0xaa, 0xff, 0xff, 0xff)
    ];
    sky.TileMode tmx = sky.TileMode.clamp;
    sky.TileMode tmy = sky.TileMode.clamp;
    List matrix4 = new vec.Matrix4.identity().storage;
    sky.ImageShader imgShader = new sky.ImageShader(img, tmx, tmy, matrix4);
    paint.shader = imgShader;
    List<int> indicies = [0, 1, 2, 3];
    ui.Vertices vertices = new ui.Vertices(
        sky.VertexMode.triangleFan,
        verticesSrc,
        colors: colors,
        textureCoordinates: textureCoordinates,
        indices: indicies
    );

    context.canvas.drawVertices(vertices, sky.BlendMode.color, paint);
  }
}

class ImageLoader {
  static skys.AssetBundle getAssetBundle() => (skys.rootBundle != null)
      ? skys.rootBundle
      : new skys.NetworkAssetBundle(new Uri.directory(Uri.base.origin));

  static Future<ui.Image> load(String url) async {
    sky.ImageStream stream = new sky.AssetImage(url, bundle: getAssetBundle()).resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    void listener(skyp.ImageInfo frame, bool synchronousCall) {
      completer.complete(frame.image);
      stream.removeListener(listener);
    }
    stream.addListener(listener);
    return completer.future;
  }
}
