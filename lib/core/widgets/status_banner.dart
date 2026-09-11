import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.title, required this.message, required this.action, required this.onTap});

  final String title;
  final String message;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.emergency,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            child: Row(
              children: [
                const Icon(Icons.emergency_rounded, color: Colors.white, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ]),
                ),
                TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
