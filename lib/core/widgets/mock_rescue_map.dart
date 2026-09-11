import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MockRescueMap extends StatelessWidget {
  const MockRescueMap({super.key, required this.distance, this.responderView = false});

  final int distance;
  final bool responderView;

  @override
  Widget build(BuildContext context) {
    final progress = (1 - ((distance - 40) / 280)).clamp(0.0, 1.0);
    return Semantics(
      label: 'Peta simulasi. Jarak penolong $distance meter.',
      child: AspectRatio(
        aspectRatio: 1.25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: LayoutBuilder(builder: (context, size) {
            final pilgrim = Offset(size.maxWidth * .70, size.maxHeight * .32);
            final start = Offset(size.maxWidth * .18, size.maxHeight * .77);
            final responder = Offset.lerp(start, pilgrim, progress)!;
            return Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: _MapPainter()),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOut,
                  left: responder.dx - 31,
                  top: responder.dy - 34,
                  child: _Marker(
                    icon: responderView ? Icons.person_pin_circle_rounded : Icons.directions_walk_rounded,
                    label: responderView ? 'Saya' : 'Ustadz Hasan',
                    color: AppColors.olive,
                  ),
                ),
                Positioned(
                  left: pilgrim.dx - 29,
                  top: pilgrim.dy - 34,
                  child: _Marker(
                    icon: Icons.person_pin_circle_rounded,
                    label: responderView ? 'Ahmad' : 'Anda',
                    color: AppColors.emergency,
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 12)]),
                    child: Row(children: [
                      const Icon(Icons.route_rounded, size: 19, color: AppColors.olive),
                      const SizedBox(width: 7),
                      Text('$distance meter', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    ]),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8)]),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
      ),
      Icon(icon, color: color, size: 38, shadows: const [Shadow(color: Colors.white, blurRadius: 5)]),
    ]);
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE8E7DD), BlendMode.srcOver);
    final block = Paint()..color = const Color(0xFFD7D8CE);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        final left = col * size.width / 4 + 8;
        final top = row * size.height / 4 + 8;
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(left, top, size.width / 5.7, size.height / 7), const Radius.circular(5)), block);
      }
    }
    final road = Paint()..color = Colors.white..strokeWidth = 20..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final roadLine = Paint()..color = const Color(0xFFCFB963)..strokeWidth = 2..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0, size.height * .82)..quadraticBezierTo(size.width * .35, size.height * .52, size.width, size.height * .25);
    canvas.drawPath(path, road);
    canvas.drawPath(path, roadLine);
    final cross = Path()..moveTo(size.width * .55, 0)..lineTo(size.width * .43, size.height);
    canvas.drawPath(cross, road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
