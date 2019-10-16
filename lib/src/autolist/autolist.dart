import 'package:autolist/src/transitions/scale_then_slide_transition.dart';
import 'package:flutter/widgets.dart';

import 'difference_set.dart';
import 'operation.dart';

/// A builder function which will build an item in the context of the animation.
/// Use this if you want to have the most control over how items are presented,
/// for example if your animation isn't simply wrapping another item widget.
///
typedef Widget AutoListCombinedItemBuilder<T>(
  BuildContext context,
  T item,
  Animation<double> animation,
);

/// A builder which will wrap a widget with an animation.
typedef Widget AutoListAnimationBuilder(
  Animation<double> animation,
  Widget child,
);

/// A builder which will build a static item in the list, leaving any
/// transition animations to be defined elsewhere.
typedef Widget AutoListItemBuilder<T>(
  BuildContext context,
  T item,
);

typedef dynamic CompareOn<T>(T elem);

/// An AutoList widget takes a list of items and turns them into a fully
/// animated list view, automatically managing insertions and deletions.
@immutable
class AutoList<T> extends StatefulWidget {
  final List<T> items;
  final AutoListCombinedItemBuilder<T> builder;
  final Duration duration;

  final CompareOn<T> compareOn;

  final padding;

  /// Build an AutoList. Exactly one of [combinedBuilder] and [itemBuilder] is
  /// required.
  ///
  /// - [items] The list of items
  /// - [duration] the duration of animations (insertions + deletions)
  /// - [combinedBuilder] see [AutoListCombinedItemBuilsder]
  /// - [animationBuilder] see [AutoListAnimationBuilder]
  /// - [itemBuilder] see [AutoListItemBuilder]
  /// - [compareOn] A transformation to run on [items] before comparing elements
  ///   for equality (to determine what needs to be inserted/removed)
  /// - [padding] Padding around the edges of the underlying [ListView]
  AutoList({
    Key key,
    @required this.items,
    @required this.duration,
    AutoListCombinedItemBuilder<T> combinedBuilder,
    AutoListAnimationBuilder animationBuilder,
    AutoListItemBuilder<T> itemBuilder,
    CompareOn<T> compareOn,
    EdgeInsetsGeometry padding,
  })  : assert(items != null),
        assert(duration != null),
        assert((combinedBuilder != null) ^ (itemBuilder != null)),
        assert(combinedBuilder == null || animationBuilder == null),
        this.compareOn = compareOn ?? ((t) => t),
        this.padding = padding ?? EdgeInsets.zero,
        this.builder = combinedBuilder ??
            ((context, item, animation) {
              animationBuilder ??= _defaultAnimationBuilder;
              return animationBuilder(
                animation,
                itemBuilder(
                  context,
                  item,
                ),
              );
            }),
        super(key: key);

  @override
  _AutoListState<T> createState() => _AutoListState();

  static AutoListAnimationBuilder _defaultAnimationBuilder = (
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleThenSlideTransition(
      animation: animation,
      child: child,
    );
  };
}

class _AutoListState<T> extends State<AutoList<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items.toList();
  }

  @override
  void didUpdateWidget(AutoList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_items == widget.items) {
      return;
    }

    List<T> oldItems = _items;
    _items = widget.items.toList();

    final difference = DifferenceSet.between(
      oldList: oldItems.map(oldWidget.compareOn),
      newList: _items.map(widget.compareOn),
    );

    difference.adjustments.forEach((adjustment) {
      switch (adjustment.operation) {
        case Operation.insert:
          _listKey.currentState.insertItem(
            adjustment.oldIndex,
            duration: widget.duration,
          );
          break;

        case Operation.remove:
          final itemToRemove = oldItems[adjustment.oldIndex];

          _listKey.currentState.removeItem(
            adjustment.newIndex,
            (context, animation) => widget.builder(
              context,
              itemToRemove,
              animation,
            ),
            duration: widget.duration,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      padding: widget.padding,
      key: _listKey,
      initialItemCount: widget.items.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return this
            .widget
            .builder(context, this.widget.items[index], animation);
      },
    );
  }
}
