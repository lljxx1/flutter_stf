import 'package:flutter/material.dart';
import './Phone.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


enum _ExpandableSlot {
  body,
  bottomBar
}


class _ExpandableLayout extends MultiChildLayoutDelegate {

  _ExpandableLayout({
    this.layoutOffetProgress,
  }) : assert(layoutOffetProgress != null);


  final double layoutOffetProgress;

  @override
  void performLayout(Size size) {

    final BoxConstraints looseConstraints = BoxConstraints.loose(size);
    final BoxConstraints fullWidthConstraints = looseConstraints.tighten(width: size.width);

    layoutChild(_ExpandableSlot.body, fullWidthConstraints);

    double totalHeight = 400;

    var lostHeight = layoutOffetProgress * totalHeight;
    var offsetTop = 0 - lostHeight;

    positionChild(_ExpandableSlot.body, Offset(0, offsetTop));

    var currentTopOffset = (fullWidthConstraints.maxHeight - (totalHeight * layoutOffetProgress)).round();
    final BoxConstraints bottombarConstraints = BoxConstraints(
        maxHeight: layoutOffetProgress > 0.0 ? totalHeight : 0,
        maxWidth: fullWidthConstraints.maxWidth,
    );

    print('currentBarHeight=$currentTopOffset totalHeight=$totalHeight layoutOffetProgress=$layoutOffetProgress');

    layoutChild(_ExpandableSlot.bottomBar, bottombarConstraints);
    positionChild(_ExpandableSlot.bottomBar, Offset(0, currentTopOffset.toDouble()));
  }

  @override
  bool shouldRelayout(_ExpandableLayout oldDelegate) {
    return oldDelegate.layoutOffetProgress != layoutOffetProgress;
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;

  AnimationController animationController = null;
  bool opend = false;

  @override
  void initState() {

    animationController = new AnimationController(
        duration: const Duration(milliseconds: 80), vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Widget mainView(){
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) {
              return PhonePage();
            }));
        },
        child: Text('open'),),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(icon: Icon(Icons.keyboard_arrow_down), onPressed: (){
                if(opend){
                  animationController.fling(velocity: -1);
                  opend = false;
                }else{
                  animationController.forward(from: 0.1);
                  opend = true;
                }
              },)
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) {
            return PhonePage();
          }));
        },
          child: Text('open'),),
      ),
    );

  }
}