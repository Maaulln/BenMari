import 'package:flutter/material.dart';

class PatientScreenBackground extends StatelessWidget {
  const PatientScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F9FB), Color(0xFFF7FAFC), Color(0xFFF8F9FB)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -120,
            right: -96,
            child: _AmbientBlob(size: 256, color: Color(0x1AFFFFFF)),
          ),
          const Positioned(
            top: 124,
            left: -96,
            child: _AmbientBlob(size: 192, color: Color(0x1AFFFFFF)),
          ),
          child,
        ],
      ),
    );
  }
}

class _AmbientBlob extends StatelessWidget {
  const _AmbientBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
