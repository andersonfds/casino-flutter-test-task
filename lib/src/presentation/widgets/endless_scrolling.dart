import 'package:flutter/material.dart';

const _kTolerance = 50.0;

bool _isOnEdge(ScrollNotification notification, double tolerance) {
  final nextExtent = notification.metrics.extentAfter;
  final isOnBottomEdge = nextExtent <= tolerance;
  return isOnBottomEdge;
}

class EndlessScrolling extends StatefulWidget {
  const EndlessScrolling({
    Key? key,
    this.onEdge,
    required this.child,
  }) : super(key: key);

  /// Callback for when the user reaches the edge of the list.
  /// This callback is called only once per scroll.
  /// Until the future is completed, the callback will not be called again.
  final VoidCallback? onEdge;
  final Widget child;

  @override
  State<EndlessScrolling> createState() => _EndlessScrollingState();
}

class _EndlessScrollingState extends State<EndlessScrolling> {
  int _edgeHitCount = 0;

  bool _onNotification(ScrollNotification notification) {
    final didHitEdge = _isOnEdge(notification, _kTolerance);

    if (!didHitEdge) {
      _edgeHitCount = 0;
      return false;
    }

    if (didHitEdge && _edgeHitCount == 0) {
      _edgeHitCount++;
      widget.onEdge?.call();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: widget.child,
    );
  }
}
