import 'package:flutter/material.dart';

enum FixableFloatingActionButtonPosition {
  end;
}

class FixableFloatingActionButton extends StatelessWidget {
  final double padding;
  final FixableFloatingActionButtonPosition position;
  final void Function() onPressed;
  final Widget? child;

  const FixableFloatingActionButton(
      {super.key,
      required this.onPressed,
      this.padding = 16.0,
      this.position = FixableFloatingActionButtonPosition.end,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: onPressed,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
