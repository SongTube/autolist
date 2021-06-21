import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class FadeAndSlideTransition extends StatelessWidget {
  final Animation<double> animation;

  final Widget child;

  const FadeAndSlideTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
    );
  }
}
