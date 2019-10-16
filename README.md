# Autolist

Animated list views, automatically.

Autolist transforms regular dart lists them into a fully
animated list views, automatically managing insertions and deletions.

## Demo

![autolist_demo](/uploads/83979c1e3fb81c77de8ed5f3ff0b02b3/autolist_demo.mov)

## To use:

See more in `example/lib/main.dart`

```dart
  AutoList<int>(
    items: _items,
    duration: Duration(milliseconds: 400),
    itemBuilder: (context, item) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(),
                ),
              ),
              child: Text(
                item.toString(),
                key: Key(item.toString()),
              ),
            ),
          ),
        ],
      );
    },
  )
```