import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';

class FlutterSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onToggle;
  final double width;
  final double height;
  final double toggleSize;
  final double borderRadius;
  final double padding;
  final Border? activeBorder;
  final Border? inactiveBorder;
  final BoxBorder? activeToggleBorder;
  final BoxBorder? inactiveToggleBorder;
  final Duration duration;
  final bool disabled;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeToggleColor;
  final Color inactiveToggleColor;
  final Widget? icon;

  const FlutterSwitch({
    required this.value,
    required this.onToggle,
    this.width = 48.0,
    this.height = 26.0,
    this.toggleSize = 20.0,
    this.borderRadius = 16.0,
    this.padding = 1.5,
    this.duration = const Duration(milliseconds: 200),
    this.disabled = false,
    this.activeColor = primary,
    this.inactiveColor = offWhite1,
    this.activeToggleColor = white,
    this.inactiveToggleColor = white,
    this.activeBorder,
    this.inactiveBorder,
    this.activeToggleBorder,
    this.inactiveToggleBorder,
    this.icon,
  });

  @override
  _ModifiedSwitchState createState() => _ModifiedSwitchState();
}

class _ModifiedSwitchState extends State<FlutterSwitch> with SingleTickerProviderStateMixin {
  late Animation<dynamic> toggleAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, value: widget.value ? 1.0 : 0.0, duration: widget.duration);
    var curveAnimation = CurvedAnimation(parent: animationController, curve: Curves.linear);
    toggleAnimation = AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight).animate(curveAnimation);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlutterSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) return;
    widget.value ? animationController.forward() : animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Align(
          child: InkWell(
            onTap: () => _switchOnTap(context),
            child: Opacity(opacity: widget.disabled ? 0.6 : 1, child: _switchWidget(context)),
          ),
        );
      },
    );
  }

  void _switchOnTap(BuildContext context) {
    if (!widget.disabled) {
      widget.value ? animationController.forward() : animationController.reverse();
      widget.onToggle(!widget.value);
    }
  }

  Widget _switchWidget(BuildContext context) {
    Color switchColor = white;
    Border? switchBorder;
    if (widget.value) {
      switchColor = widget.activeColor;
      switchBorder = widget.activeBorder;
    } else {
      switchColor = widget.inactiveColor;
      switchBorder = widget.inactiveBorder;
    }
    var radius = BorderRadius.circular(widget.borderRadius);
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(widget.padding),
      decoration: BoxDecoration(borderRadius: radius, color: switchColor, border: switchBorder),
      child: Stack(children: <Widget>[_toggleWidget(context)]),
    );
  }

  Widget _toggleWidget(BuildContext context) {
    Color toggleColor = white;
    Border? toggleBorder;
    if (widget.value) {
      toggleColor = widget.activeToggleColor;
      toggleBorder = widget.activeToggleBorder as Border?;
    } else {
      toggleColor = widget.inactiveToggleColor;
      toggleBorder = widget.inactiveToggleBorder as Border?;
    }

    return Align(
      alignment: toggleAnimation.value,
      child: Container(
        width: widget.toggleSize,
        height: widget.toggleSize,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(shape: BoxShape.circle, color: toggleColor, border: toggleBorder),
        child: FittedBox(
          child: Stack(
            children: [
              Center(child: AnimatedOpacity(opacity: widget.value ? 1.0 : 0.0, duration: widget.duration)),
              Center(child: AnimatedOpacity(opacity: !widget.value ? 1.0 : 0.0, duration: widget.duration)),
              if (widget.icon != null) widget.icon!,
            ],
          ),
        ),
      ),
    );
  }
}
