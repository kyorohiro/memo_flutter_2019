//import 'package:flutter/material.dart' as sky;
import 'package:flutter/widgets.dart'as sky;

void main() {
  sky.runApp( new sky.Directionality(
      textDirection: sky.TextDirection.ltr,
      child: new sky.Center (
          child: new sky.Text("Hello World",
              style: new sky.TextStyle(color:new sky.Color.fromARGB(0xff,0xff,0xff,0xff)))
      )
  ));
}
