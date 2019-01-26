import 'dart:async';
import 'dart:ui' as skyui;

import 'package:flutter/rendering.dart' as sky;
import 'package:flutter/services.dart' as sky;
import 'package:flutter/widgets.dart' as sky;
import 'package:flutter/material.dart' as sky;
import 'package:flutter/painting.dart' as sky;
import 'dart:io' as io;
import 'dart:typed_data';

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
  double x = 50.0;
  double y = 50.0;
  skyui.Image image = null;
  DemoObject() : super(additionalConstraints: const sky.BoxConstraints.expand()) {
    ;
  }
  loadImage() async {
    if (image == null) {
      image = await ImageLoader.load("https://avatars0.githubusercontent.com/u/1310669");
      this.markNeedsPaint();
    }
  }

  @override
  bool hitTestSelf(sky.Offset position) => true;

  @override
  void handleEvent(sky.PointerEvent event, sky.BoxHitTestEntry entry) {}

  @override
  void paint(sky.PaintingContext context, sky.Offset offset) {
    loadImage();
    sky.Paint paint = new sky.Paint()..color = new sky.Color.fromARGB(0xff, 0xff, 0xff, 0xff);
    sky.Offset point = new sky.Offset(x, y);
    if (image == null) {
      sky.Rect rect = new sky.Rect.fromLTWH(x, y, 50.0, 50.0);
      context.canvas.drawRect(rect, paint);
    } else {
      context.canvas.drawImage(image, point, paint);
    }
  }

}

class ImageLoader {
  static Future<skyui.Image> load(String url) async {
    io.HttpClient client = new io.HttpClient();
    io.HttpClientRequest request = await client.getUrl(Uri.parse(url));
    io.HttpClientResponse response = await request.close();


    if (response.statusCode != 200) {
      throw {"message": "failed to load ${url}"};
    } else {
      //Uint8List bytes = new Uint8List(await response.length);
      int i = 0;
      List bytesSrc = <int>[];
      await for (List<int> d in response) {
        bytesSrc.addAll(d);
      }
      Uint8List bytes = new Uint8List.fromList(bytesSrc);
      // normally use following
      // import 'package:flutter/services.dart';
      // Future<ui.Image> decodeImageFromDataPipe(MojoDataPipeConsumer consumerHandle)
      // Future<ui.Image> decodeImageFromList(Uint8List list) {
      Completer<skyui.Image> completer = new Completer();
      skyui.decodeImageFromList(bytes, (skyui.Image image) {
        completer.complete(image);
      });
      return completer.future;
    }
  }
}
