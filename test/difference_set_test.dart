import 'package:autolist/autolist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Insert after remove', () {
    final diff = DifferenceSet.between(oldList: [1, 2, 3], newList: [2, 4, 3])!;

    expect(
      diff.adjustments,
      equals([
        Adjustment(Operation.remove, 0, 0),
        Adjustment(Operation.insert, 1, 2),
      ]),
    );
  });

  test('Remove after insert', () {
    final diff = DifferenceSet.between(oldList: [1, 2, 3], newList: [4, 1, 3])!;

    expect(
      diff.adjustments,
      equals([
        Adjustment(Operation.insert, 0, 0),
        Adjustment(Operation.remove, 1, 2),
      ]),
    );
  });

  test('Remove two', () {
    final diff = DifferenceSet.between(oldList: [1, 2, 3, 4], newList: [2, 3])!;

    expect(
      diff.adjustments,
      equals([
        Adjustment(Operation.remove, 0, 0),
        Adjustment(Operation.remove, 3, 2),
      ]),
    );
  });
}
