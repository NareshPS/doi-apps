import 'package:flutter/material.dart';

class ToggleIconButton extends StatefulWidget {
  final bool on;
  final IconData iconData;
  
  final Function? onOn;
  final Function? onOff;

  const ToggleIconButton({
      super.key,
      required this.iconData,
      this.on=false,
      this.onOn,
      this.onOff
    }
  );

  @override
  State<ToggleIconButton> createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  late bool on;

  @override
  void initState() {
    super.initState();
    on = widget.on;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => on = !on);
        if (on) widget.onOn!();
        if (!on) widget.onOff!();
      },
      icon: on
        ? Icon(widget.iconData, color: Colors.red[400]!)
        : Icon(widget.iconData, color: Colors.grey[800],)
    );
  }
}