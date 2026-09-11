import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FawjBrand extends StatelessWidget {
  const FawjBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'FAWJ, فوج',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'FAWJ',
            style: TextStyle(
              color: AppColors.olive,
              fontSize: compact ? 21 : 25,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 22, color: AppColors.gold),
          const SizedBox(width: 8),
          Text('فوج', style: TextStyle(color: AppColors.olive, fontSize: compact ? 19 : 23, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
