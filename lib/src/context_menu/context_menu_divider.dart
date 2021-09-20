import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'context_menu_entry.dart';

class ContextMenuDivider<Never> extends ContextMenuEntry<Never> {
  @override
  State<ContextMenuDivider> createState() => _ContextMenuDividerState();
}

class _ContextMenuDividerState extends State<ContextMenuDivider> {

  @override
  Widget build(BuildContext context) {
    return Divider(
              color: const Color(0xFFCFCCCE),
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.0,
            );
  }
}