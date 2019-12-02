
import 'package:flutter/material.dart';

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



class ExpandablePage extends StatefulWidget {

  ExpandablePage({
    this.bottomBar,
    this.body
  });

  final Widget body;
  final Widget bottomBar;

  @override
  State<StatefulWidget> createState() => ExpandablePageState();
}


class ExpandablePageState extends State<ExpandablePage> with TickerProviderStateMixin {


  AnimationController offsetAnimationController = null;

  @override
  void initState() {

    offsetAnimationController = new AnimationController(
        duration: const Duration(milliseconds: 80),
        vsync: this
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    offsetAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(animation: offsetAnimationController, builder: (BuildContext context, Widget child) {
      return CustomMultiChildLayout(
          children: <Widget>[
            LayoutId(
              id: _ExpandableSlot.body,
              child: widget.body,
            ),
            LayoutId(
              id: _ExpandableSlot.bottomBar,
              child: widget.bottomBar,
            )
          ],
          delegate: _ExpandableLayout(
              layoutOffetProgress: offsetAnimationController.value
          )
      );
    });
  }
}