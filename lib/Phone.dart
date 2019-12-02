
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:collection';
import 'dart:ui' as ui;

class PhonePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PhoneSate();
}


class PhoneScreenView extends CustomPainter {

  ui.Image img;

  PhoneScreenView(this.img);

  @override
  void paint(Canvas canvas, Size size) {
    if(img != null){
      canvas.drawImage(img, new Offset(0, 0), new Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}




class _PhoneSate extends State<PhonePage> {
  final channel = new IOWebSocketChannel.connect('ws://192.168.41.148:7400/');

  Queue paintList = new Queue();

  @override
  void initState() {

    channel.sink.add("size 692x692");
    channel.sink.add("on");

//    channel.stream.listen((message) {
//      if(message is String){
//        print(message);
//      }else{
//        addImage(message);
//      }
//    });


//   size 692x692
//   on
    // TODO: implement initState
    super.initState();
  }

   addImage(message) async {
     ui.Codec codec = await ui.instantiateImageCodec(message);
     ui.FrameInfo frame = await codec.getNextFrame();
     paintList.add(frame.image);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: addImage(snapshot.data),
            builder: (c, a) {
              return CustomPaint(
                painter: PhoneScreenView(a.data),
              );
            },
          );
        },
      ),
    );
  }
}