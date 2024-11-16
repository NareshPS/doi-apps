import 'package:flutter/material.dart';

enum SeparatedColumnCushion { start, end, both, none }

class SeparatedColumn extends StatelessWidget {
  final Widget Function(BuildContext context) separator;
  final List<Widget> children;
  final SeparatedColumnCushion cushion;

  const SeparatedColumn(
      {super.key,
      required this.separator,
      required this.children,
      this.cushion = SeparatedColumnCushion.start});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildChildren(context),
    );
  }

  addStartCushion(context, separatedChildren) {
    if (cushion == SeparatedColumnCushion.start ||
        cushion == SeparatedColumnCushion.both) {
      separatedChildren.add(separator(context));
    }
  }

  addEndCushion(context, separatedChildren) {
    if (!(cushion == SeparatedColumnCushion.end ||
        cushion == SeparatedColumnCushion.both)) {
      separatedChildren.removeLast();
    }
  }

  buildChildren(context) {
    final separatedChildren = <Widget>[];

    addStartCushion(context, separatedChildren);
    separatedChildren
        .addAll(children.expand((element) => [element, separator(context)]));
    addEndCushion(context, separatedChildren);

    return separatedChildren;
  }
}
