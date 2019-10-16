# Autolist

[![pub package](https://img.shields.io/pub/v/autolist?color=blue&style=flat-square)](https://pub.dev/packages/autolist)

Animated list views, automatically.

Autolist transforms regular dart lists them into a fully
animated list views, automatically managing insertions and deletions.

## Demo

![autolist_demo](https://gitlab.com/benweitzman/autolist/uploads/b6c0666342803528d069474ad0b48fe7/autolist_demo.gif)

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