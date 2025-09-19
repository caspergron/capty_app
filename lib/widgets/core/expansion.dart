import 'package:flutter/material.dart';

const _kExpand = Duration(milliseconds: 250);

class Expansion extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final Decoration tileDecoration;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Widget? trailing;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final ListTileControlAffinity? controlAffinity;

  const Expansion({
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.controlAffinity,
    this.tileDecoration = const BoxDecoration(),
  }) : assert(expandedCrossAxisAlignment != CrossAxisAlignment.baseline);

  @override
  State<Expansion> createState() => _ExpansionState();
}

class _ExpansionState extends State<Expansion> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  Animatable<double> _halfTween = Tween<double>(begin: 0, end: 0.5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((value) {
          if (!mounted) return;
          setState(() {});
          // Rebuild without widget.children.
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final expansionTileTheme = ExpansionTileTheme.of(context);
    final closed = !_isExpanded && _controller.isDismissed;
    final shouldRemoveChildren = closed && !widget.maintainState;
    final crossAlign = widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.start;
    final padding = widget.childrenPadding ?? expansionTileTheme.childrenPadding ?? EdgeInsets.zero;
    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(padding: padding, child: Column(crossAxisAlignment: crossAlign, children: widget.children)),
      ),
    );
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final height = const SizedBox(height: 4);
    final isSubTitle = widget.subtitle != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: _handleTap,
          child: Container(
            width: double.infinity,
            decoration: widget.tileDecoration,
            padding: widget.tilePadding ?? const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [widget.title, if (isSubTitle) height, if (isSubTitle) widget.subtitle!],
                  ),
                ),
                const SizedBox(width: 20),
                RotationTransition(turns: _iconTurns, child: widget.trailing),
              ],
            ),
          ),
        ),
        ClipRect(
          child: Align(
            alignment: widget.expandedAlignment ?? Alignment.centerLeft,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }
}
