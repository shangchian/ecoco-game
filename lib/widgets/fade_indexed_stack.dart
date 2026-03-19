import 'package:flutter/material.dart';

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _currentIndex;
  int? _previousIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addStatusListener(_onAnimationStatusChanged);
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _previousIndex = null;
      });
    }
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _currentIndex) {
      _previousIndex = _currentIndex;
      _currentIndex = widget.index;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: List.generate(widget.children.length, (index) {
            final isCurrent = index == _currentIndex;
            final isPrevious = index == _previousIndex;

            // If the child is not current and not previous, hide it but keep state
            if (!isCurrent && !isPrevious) {
              return Visibility(
                maintainState: true,
                visible: false,
                child: widget.children[index],
              );
            }

            // Calculate opacity for fading children
            // FIX: To prevent background flashing, getting "Fade Over" effect:
            // The element higher in the stack (higher index) animates opacity.
            // The element lower in the stack (lower index) stays opaque (1.0).
            double opacity = 1.0;

            if (_previousIndex != null) {
              final topIndex = _currentIndex; // 新頁永遠在上層

              if (index == topIndex) {
                // 只讓新頁淡入，底層保持不透明，避免露白
                opacity = _controller.value;
              } else {
                opacity = 1.0;
              }
            }

            return IgnorePointer(
              ignoring: !isCurrent, // Prevent interaction with fading-out widget
              child: Opacity(
                opacity: opacity,
                child: widget.children[index],
              ),
            );
          }),
        );
      },
    );
  }
}
