import 'package:flutter/cupertino.dart';

import 'operation.dart';

@visibleForTesting
class Adjustment {
  final Operation operation;
  final int oldIndex;
  final int newIndex;

  Adjustment(this.operation, this.oldIndex, this.newIndex);

  @override
  String toString() {
    return 'Adjustment{operation: $operation, oldIndex: $oldIndex, newIndexOffset: $newIndex}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Adjustment &&
          runtimeType == other.runtimeType &&
          operation == other.operation &&
          oldIndex == other.oldIndex &&
          newIndex == other.newIndex;

  @override
  int get hashCode =>
      operation.hashCode ^ oldIndex.hashCode ^ newIndex.hashCode;
}
