import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'size_no_clip_transition.dart';

@immutable
class ScaleThenSlideTransition extends StatelessWidget {
  final Animation<double> animation;

  final Widget child;

  const ScaleThenSlideTransition({
    Key key,
    @required this.animation,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Interval(0.5, 1)))
          .drive(CurveTween(curve: Curves.easeOutQuint))
          .drive(Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          )),
      child: SizeNoClipTransition(
        sizeFactor: animation
            .drive(CurveTween(curve: Interval(0, 0.5)))
            .drive(CurveTween(curve: Curves.easeInOut)),
        child: child,
      ),
    );
  }
}
