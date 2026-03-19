import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying profile page sections with white background and rounded corners
class ProfileSection extends StatelessWidget {
  final String title;
  final dynamic icon; // Can be IconData or String (asset path)
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              icon is String
                  ? Image.asset(
                      icon,
                      width: 27,
                      height: 27,
                    )
                  : Icon(icon as IconData, size: 24),
              const SizedBox(width: 8),
              Flexible(child: FittedBox(
                fit: BoxFit.scaleDown,
                child:Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ))),
            ],
          ),
        ),
        // White Container with rounded corners
        Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: children.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.dividerColor,
            ),
            itemBuilder: (context, index) => children[index],
          ),
        ),
      ],
    );
  }
}
