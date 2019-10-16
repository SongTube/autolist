import 'package:flutter/cupertino.dart';

import 'adjustment.dart';
import 'operation.dart';

@visibleForTesting
class DifferenceSet implements Comparable<DifferenceSet> {
  final List<Adjustment> adjustments;

  DifferenceSet._(this.adjustments);

  static DifferenceSet between<T>({Iterable<T> oldList, Iterable<T> newList}) {
    // d[i][j] will hold the edit sequence between the first i characters of the
    // old list and the first j characters of the new list.
    List<List<DifferenceSet>> d = List.generate(oldList.length + 1, (_) {
      return List.filled(newList.length + 1, null);
    });

    // the edit sequence between empty lists is empty.
    d[0][0] = DifferenceSet._([]);

    // the edit sequence between any old list of length i and an empty list is
    // a list of i removals.
    for (var i = 1; i <= oldList.length; i++) {
      d[i][0] = _removal(d, i - 1, 0);
    }

    // the edit sequence between an empty list and any new list of length j is
    // a list of j insertions.
    for (var j = 1; j <= newList.length; j++) {
      d[0][j] = _insertion(d, 0, j - 1);
    }

    // iteratively fill in the remaining edit distances.
    for (var j = 1; j <= newList.length; j++) {
      for (var i = 1; i <= oldList.length; i++) {
        final delete = _removal(d, i - 1, j);
        final insert = _insertion(d, i, j - 1);

        final DifferenceSet strictEdit = _min(delete, insert);

        // divergence from the levenshtein algorithm: if the elements that we
        // are looking at pairwise are not equal, we don't allow for a
        // substitution, i.e. there must be a deletion or an insertion.
        //
        // if the elements are equal, we take the minimum of the smallest strict
        // edit and the identity operation (i.e. do nothing).
        if (newList.elementAt(j - 1) == oldList.elementAt(i - 1)) {
          d[i][j] = _min(strictEdit, d[i - 1][j - 1]);
        } else {
          d[i][j] = strictEdit;
        }
      }
    }

    return d[oldList.length][newList.length];
  }

  static A _min<A extends Comparable<A>>(A x, A y) {
    if (x.compareTo(y) < 0) {
      return x;
    } else {
      return y;
    }
  }

  static DifferenceSet _insertion(List<List<DifferenceSet>> d, int i, int j) {
    return DifferenceSet._(
      d[i][j].adjustments + [Adjustment(Operation.insert, j, i)],
    );
  }

  static DifferenceSet _removal(List<List<DifferenceSet>> d, int i, int j) {
    return DifferenceSet._(
      d[i][j].adjustments + [Adjustment(Operation.remove, i, j)],
    );
  }

  @override
  String toString() {
    return 'DifferenceSet{adjustments: $adjustments}';
  }

  @override
  int compareTo(DifferenceSet other) {
    return this.adjustments.length.compareTo(other.adjustments.length);
  }
}
