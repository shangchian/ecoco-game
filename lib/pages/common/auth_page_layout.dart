import 'package:flutter/material.dart';

/// Reusable layout component for authentication pages (login, forget password, register)
/// Provides consistent yellow background with white rounded container
class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.child,
    this.showYellowBackground = true, // Renamed for clarity, controls only internal image
    this.topPadding = 160,
  });

  final Widget child;
  final bool showYellowBackground;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background image with rounded corners (fixed position)
        if (showYellowBackground)
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            height: screenHeight - topPadding,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: const Offset(-50, 50),
                      child: Image.asset(
                        'assets/images/background_e.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Main content container - fixed height to prevent resizing
        Positioned(
          top: topPadding,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: child,
          ),
        ),
      ],
    );
  }
}
