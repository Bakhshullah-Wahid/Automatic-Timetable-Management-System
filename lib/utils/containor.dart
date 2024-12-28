import 'package:flutter/material.dart';

class TheContainer extends StatelessWidget {
  final Widget child;
  final dynamic width;
  final dynamic height;
  const TheContainer({super.key, required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the container
        borderRadius: BorderRadius.circular(8), // Optional: rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            offset: const Offset(0, 1), // Shadow only below
            blurRadius: 3, // Controls how blurry the shadow is
            spreadRadius: 0.4, // Spread of the shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
