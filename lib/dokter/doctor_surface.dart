import 'package:flutter/material.dart';

class DoctorScreenBackground extends StatelessWidget {
  const DoctorScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8FAFC), Color(0xFFF3F7FF)],
            ),
          ),
        ),
        const Positioned(
          top: -80,
          right: -60,
          child: _AmbientBlob(size: 180, color: Color(0x1A155DFC)),
        ),
        const Positioned(
          bottom: 140,
          left: -70,
          child: _AmbientBlob(size: 160, color: Color(0x14009666)),
        ),
        child,
      ],
    );
  }
}

class _AmbientBlob extends StatelessWidget {
  const _AmbientBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
