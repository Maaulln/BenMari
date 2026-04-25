import 'package:flutter/material.dart';

class DoctorCardContainer extends StatelessWidget {
  const DoctorCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.decoration,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          decoration ??
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
      child: Padding(padding: padding, child: child),
    );
  }
}
