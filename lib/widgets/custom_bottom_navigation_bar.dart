import 'package:flutter/material.dart';
import '/constants/colors.dart';

// Navigation bar size constants
const double _kNavBarHeight = 80.0;
const double _kBubbleSize = 36.0;
const double _kIconSize = 36.0;

// Notch constants
const double _kNotchWidth = 36.0;
const double _kNotchDepth = 5.0;

// Animation timing: 167ms deselect + 33ms gap + 167ms select = 367ms total
const Duration _kTotalSequenceDuration = Duration(milliseconds: 367);

// Animation phase boundaries (normalized 0.0 - 1.0)
const double _kDeselectEnd = 0.4550; // 167ms / 367ms
const double _kSelectStart = 0.5450; // 200ms / 367ms

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _sequenceController;
  int _previousIndex = -1;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(
      duration: _kTotalSequenceDuration,
      vsync: this,
    );
    _previousIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When tab changes, start the sequential animation
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _sequenceController.reset();
      _sequenceController.forward();
    }
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    super.dispose();
  }

  /// Calculate the selection progress for a specific item index
  /// Returns 0.0 (unselected) to 1.0 (fully selected)
  double _getItemProgress(int index, double animationValue) {
    // First build - show current selection immediately
    if (_isFirstBuild) {
      return index == widget.currentIndex ? 1.0 : 0.0;
    }

    // Animation not running - show final state
    if (!_sequenceController.isAnimating && _sequenceController.value == 0.0) {
      return index == widget.currentIndex ? 1.0 : 0.0;
    }

    // Animation completed - show final state
    if (_sequenceController.isCompleted) {
      return index == widget.currentIndex ? 1.0 : 0.0;
    }

    // During animation - calculate progress based on phase
    if (index == _previousIndex) {
      // Deselecting item: 1.0 -> 0.0 during deselect phase (0.0 to _kDeselectEnd)
      if (animationValue <= _kDeselectEnd) {
        // First calculate linear progress 0→1, apply curve, then invert to get 1→0
        final linearProgress = animationValue / _kDeselectEnd;
        final curvedProgress = Curves.easeInOutCubic.transform(linearProgress.clamp(0.0, 1.0));
        return 1.0 - curvedProgress;
      }
      return 0.0;
    } else if (index == widget.currentIndex) {
      // Selecting item: 0.0 -> 1.0 during select phase (_kSelectStart to 1.0)
      if (animationValue >= _kSelectStart) {
        // Map _kSelectStart-1.0 to 0.0-1.0
        final progress = (animationValue - _kSelectStart) / (1.0 - _kSelectStart);
        return Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
      }
      return 0.0;
    }

    // Other items stay unselected
    return 0.0;
  }

  /// Calculate notch depth based on animation state
  double _getNotchDepth(double animationValue) {
    // First build - show notch immediately
    if (_isFirstBuild) {
      return _kNotchDepth;
    }

    // Animation not running - show full depth
    if (!_sequenceController.isAnimating && _sequenceController.value == 0.0) {
      return _kNotchDepth;
    }

    // Animation completed - show full depth
    if (_sequenceController.isCompleted) {
      return _kNotchDepth;
    }

    // During select phase - animate notch appearing
    if (animationValue >= _kSelectStart) {
      final progress = (animationValue - _kSelectStart) / (1.0 - _kSelectStart);
      return _kNotchDepth * Curves.easeOut.transform(progress.clamp(0.0, 1.0));
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Mark first build as complete after initial frame
    if (_isFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isFirstBuild = false;
          });
        }
      });
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        height: _kNavBarHeight + bottomInset,
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the center position of each item
            final itemWidth = constraints.maxWidth / widget.items.length;
            final targetNotchPosition = (widget.currentIndex + 0.5) * itemWidth;

            return AnimatedBuilder(
              animation: _sequenceController,
              builder: (context, child) {
                final animationValue = _sequenceController.value;
                final notchDepth = _getNotchDepth(animationValue);

                return CustomPaint(
                  painter: _BottomNavBarPainter(
                    notchPosition: targetNotchPosition,
                    notchDepth: notchDepth,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black.withValues(alpha: 0.1),
                    shadowBlurRadius: 8,
                  ),
                  child: SafeArea(
                    top: false,
                    bottom: true,
                    child: SizedBox(
                      height: _kNavBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          widget.items.length,
                          (index) {
                            final progress = _getItemProgress(index, animationValue);
                            return Expanded(
                              child: _CustomBottomNavItem(
                                icon: widget.items[index].icon,
                                label: widget.items[index].label ?? '',
                                progress: progress,
                                onTap: () => widget.onTap(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CustomBottomNavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final double progress; // 0.0 (unselected) to 1.0 (fully selected)
  final VoidCallback onTap;

  const _CustomBottomNavItem({
    required this.icon,
    required this.label,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.primaryHighlightColor;
    final unselectedColor = Colors.grey[600]!;

    // Calculate interpolated colors based on progress
    final iconColor = Color.lerp(unselectedColor, Colors.white, progress)!;
    final labelColor = Color.lerp(unselectedColor, selectedColor, progress)!;
    final fontWeight = progress > 0.5 ? FontWeight.w600 : FontWeight.w500;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: selectedColor.withValues(alpha: 0.2),
      highlightColor: selectedColor.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 0.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with animated bubble background
            Transform.translate(
              offset: const Offset(0, -12.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated bubble with opacity + scale
                  Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: Container(
                        width: _kBubbleSize,
                        height: _kBubbleSize,
                        decoration: BoxDecoration(
                          color: AppColors.primaryHighlightColor,
                          borderRadius: BorderRadius.circular(_kBubbleSize / 2),
                        ),
                      ),
                    ),
                  ),
                  // Icon with interpolated color
                  IconTheme(
                    data: IconThemeData(
                      color: iconColor,
                      size: _kIconSize,
                    ),
                    child: icon,
                  ),
                ],
              ),
            ),

            // Label with interpolated color
            Transform.translate(
              offset: const Offset(0, -10.0),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: fontWeight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws the bottom navigation bar background
/// with a curved notch at the top edge for the selected item
class _BottomNavBarPainter extends CustomPainter {
  final double notchPosition; // Center X position of the notch
  final double
      notchDepth; // Animated depth of the notch (0 = flat, full = curved)
  final Color backgroundColor;
  final Color shadowColor;
  final double shadowBlurRadius;

  _BottomNavBarPainter({
    required this.notchPosition,
    required this.notchDepth,
    required this.backgroundColor,
    required this.shadowColor,
    required this.shadowBlurRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = _createNotchedPath(size);

    // Draw top shadow using blur with upward offset
    final shadowPaint = Paint()
      ..color = shadowColor.withValues(alpha: 0.2) // Increase opacity for visibility
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, shadowBlurRadius / 2);

    // Shift path upward slightly to create top-only shadow effect
    final shadowPath = path.shift(const Offset(0, -1.5));
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw background on top to cover any bottom/side shadows
    canvas.drawPath(path, paint);
  }

  Path _createNotchedPath(Size size) {
    final path = Path();

    // Calculate notch boundaries
    final notchLeft = notchPosition - (_kNotchWidth / 2);
    final notchRight = notchPosition + (_kNotchWidth / 2);

    // Start from top-left corner
    path.moveTo(0, 0);

    // Draw to the start of the notch
    path.lineTo(notchLeft, 0);

    // Draw the arc or straight line based on depth
    if (notchDepth > 0.1) {
      // Calculate circular arc parameters
      // For a circular arc, we need to find the radius that creates the desired depth
      // Using the formula: radius = (width² + 4*depth²) / (8*depth)
      final width = _kNotchWidth;
      final radius =
          (width * width + 4 * notchDepth * notchDepth) / (8 * notchDepth);

      // Draw the circular arc (upward/outward curve - 向上凸出)
      // Arc from left to right, curving upward
      path.arcToPoint(
        Offset(notchRight, 0),
        radius: Radius.circular(radius),
        clockwise: true, // Clockwise for upward arc
      );
    } else {
      // When depth is ~0, draw a straight line (flat)
      path.lineTo(notchRight, 0);
    }

    // Continue to top-right corner
    path.lineTo(size.width, 0);

    // Draw right edge
    path.lineTo(size.width, size.height);

    // Draw bottom edge
    path.lineTo(0, size.height);

    // Draw left edge and close
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(_BottomNavBarPainter oldDelegate) {
    return oldDelegate.notchPosition != notchPosition ||
        oldDelegate.notchDepth != notchDepth ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
