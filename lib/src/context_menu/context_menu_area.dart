library context_menu;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'context_menu_entry.dart';
import 'context_menu_item.dart';
import 'context_menu_divider.dart';

typedef ContextMenuItemBuilder<T> = List<ContextMenuEntry<T>> Function(BuildContext context);
typedef ContextMenuItemSelected<T> = void Function(T);

const double _kMenuScreenPadding = 8.0;

/// The witdth of one context menu container
const double kContextMenuWidth = 180.0;

class ContextMenuArea<T> extends StatelessWidget {
  const ContextMenuArea({required this.itemBuilder, required this.child, this.itemSelected, Key? key}) : super(key: key);

  final Widget child;
  final ContextMenuItemBuilder<T> itemBuilder;
  final ContextMenuItemSelected<T?>? itemSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        var res = await showContextMenu<T>(
          context: context, 
          position: details.globalPosition,
          builder: itemBuilder,
        );
        itemSelected?.call(res);
      },
      child: child,
    );
  }
}

Future<T?> showContextMenu<T>({
  required BuildContext context,
  required Offset position,
  required ContextMenuItemBuilder<T> builder,
}) {
  final MediaQueryData mediaQuery = MediaQuery.of(context);

  var items = builder(context);

  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ContextMenu',
      barrierColor: null,
      builder: (context) {
        return CustomSingleChildLayout(
            delegate: _ContextMenuDelegate(
              position: position,
              padding: mediaQuery.padding,
            ),
            child: _Menu<T>(items: items),);
      },);
}

class _ContextMenuDelegate extends SingleChildLayoutDelegate {
  _ContextMenuDelegate({required this.position, required this.padding});

  final EdgeInsets padding;
  final Offset position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var dx = position.dx;
    var dy = position.dy;
    if ((position.dx + childSize.width) >= size.width) {
      dx = position.dx - childSize.width;
    }
    if ((position.dy + childSize.height) >= size.height) {
      dy = position.dy - childSize.height;
    }


    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class _Menu<T> extends StatelessWidget {
  const _Menu({required this.items, Key? key}) : super(key: key);
  final List<ContextMenuEntry<T>> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: const Color(0xFFEAE7EA),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset.zero, blurRadius: 3.0),
          ],
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 1.0,),
          borderRadius: BorderRadius.circular(5.0),),
      width: kContextMenuWidth,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      ),
    );
  }
}


