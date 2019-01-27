import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as sky;
import 'dart:async';
import 'dart:typed_data';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;


main() async {
  // "assets/icon.jpeg" is error 2015/12/13 's flutter, when draw image

  runApp(new DrawVertexsWidget());
}

class DrawVertexsWidget extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return new DrawVertexsObject()..anime();
  }
}

class DrawVertexsObject extends RenderConstrainedBox {
  sky.Image img = null;
  double angle = 0.0;
  DrawVertexsObject()
      : super(additionalConstraints: const BoxConstraints.expand()) {
    loadImage();
  }

  void anime() {
    SchedulerBinding.instance.scheduleFrameCallback((Duration timeStamp) {
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
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {}

  @override
  void paint(PaintingContext context, Offset offset) {
    if(img == null) {
      return;
    }
    context.canvas.scale(4.0, 4.0);
    context.canvas.translate(50.0, 80.0);
    Matrix4 mat = new Matrix4.identity();
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
  }

  void drawSurface(PaintingContext context, Offset offset, Matrix4 mat) {
    Paint paint = new Paint();
    sky.VertexMode vertexMode = sky.VertexMode.triangleFan;
    Vector3 vec1 = mat * new Vector3(-25.0, -25.0, -25.0);
    Vector3 vec2 = mat * new Vector3(-25.0, 25.0, -25.0);
    Vector3 vec3 = mat * new Vector3(25.0, 25.0, -25.0);
    Vector3 vec4 = mat * new Vector3(25.0, -25.0, -25.0);
    Vector3 normal = (vec1 - vec2).cross(vec1 - vec3);
    if (normal.z < 0) {
      return;
    }
    List<Offset> verticesSrc = [
      new Offset(vec1.x, vec1.y),
      new Offset(vec2.x, vec2.y),
      new Offset(vec3.x, vec3.y),
      new Offset(vec4.x, vec4.y)
    ];
    List<Offset> textureCoordinates = [
      new Offset(0.0, 0.0),
      new Offset(0.0, 1.0 * img.height),
      new Offset(1.0 * img.width, 1.0 * img.height),
      new Offset(1.0 * img.width, 0.0)
    ];
    List<Color> colors = [
      const Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
      const Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
      const Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
      const Color.fromARGB(0xaa, 0xff, 0xff, 0xff)
    ];
    sky.TileMode tmx = sky.TileMode.clamp;
    sky.TileMode tmy = sky.TileMode.clamp;
    Float64List matrix4 = new Matrix4.identity().storage;
    sky.ImageShader imgShader = new sky.ImageShader(img, tmx, tmy, matrix4);
    paint.shader = imgShader;
    List<int> indicies = [0, 1, 2, 3];
    sky.Vertices vertices = new sky.Vertices(
        sky.VertexMode.triangleFan,
        verticesSrc,
        colors: colors,
        textureCoordinates: textureCoordinates,
        indices: indicies
    );

    context.canvas.drawVertices(vertices, BlendMode.color, paint);
  }
}

class ImageLoader {
  static AssetBundle getAssetBundle() => (rootBundle != null)
      ? rootBundle
      : new NetworkAssetBundle(new Uri.directory(Uri.base.origin));

  static Future<sky.Image> load(String url) async {
    ImageStream stream = new AssetImage(url, bundle: getAssetBundle()).resolve(ImageConfiguration.empty);
    Completer<sky.Image> completer = new Completer<sky.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final sky.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    }
    stream.addListener(listener);
    return completer.future;
  }
}
