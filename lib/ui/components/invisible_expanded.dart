import 'dart:math';

import 'package:flutter/material.dart';

class InvisibleExpandedHeader extends StatefulWidget {
  final Widget child;
  final bool reversed;

  const InvisibleExpandedHeader({
    Key? key,
    required this.child,
    this.reversed = false,
  }) : super(key: key);

  @override
  _InvisibleExpandedHeaderState createState() {
    return _InvisibleExpandedHeaderState();
  }
}

class _InvisibleExpandedHeaderState extends State<InvisibleExpandedHeader> {
  ScrollPosition? _position;
  bool? _visible;
  double? _opacity;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings != null) {
      bool visible =
          settings.currentExtent > (settings.maxExtent - settings.minExtent + 25);
      double minimum = settings.minExtent / settings.maxExtent;
      double opacity =
          min(settings.currentExtent, settings.maxExtent) / settings.maxExtent;
      opacity = (opacity - minimum) / (1 - minimum);
      if (widget.reversed) {
        visible = !visible;
        opacity = 1 - opacity;
      }
      setState(() {
        _visible = visible;
        _opacity = opacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity ?? 1,
      child: Visibility(
        visible: _visible ?? false,
        child: widget.child,
      ),
    );
  }
}
