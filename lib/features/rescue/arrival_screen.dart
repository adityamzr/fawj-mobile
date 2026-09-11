import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';

class ArrivalScreen extends StatelessWidget {
  const ArrivalScreen({super.key, required this.controller});
  final PrototypeController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 92, height: 92, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: .28), shape: BoxShape.circle), child: const Icon(Icons.person_pin_circle_rounded, size: 52, color: AppColors.olive)),
      const SizedBox(height: 28),
      Text('${MockData.responder} mengatakan\ntelah sampai di lokasi Anda.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 14),
      const Text('Apakah Anda sudah bertemu?', style: TextStyle(fontSize: 18)),
      const SizedBox(height: 30),
      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => controller.confirmMet(true), icon: const Icon(Icons.check_circle_rounded), label: const Text('YA, SUDAH'))),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => controller.confirmMet(false), icon: const Icon(Icons.search_rounded), label: const Text('BELUM'))),
    ])));
  }
}

class ResolvedScreen extends StatelessWidget {
  const ResolvedScreen({super.key, required this.controller});
  final PrototypeController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 108, height: 108, decoration: BoxDecoration(color: AppColors.success.withValues(alpha: .12), shape: BoxShape.circle), child: const Icon(Icons.task_alt_rounded, size: 64, color: AppColors.success)),
      const SizedBox(height: 28),
      Text('Alhamdulillaah', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.success)),
      const SizedBox(height: 12),
      const Text('Bantuan telah selesai.\nAnda telah bertemu dengan\n${MockData.responder}.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, height: 1.5)),
      const SizedBox(height: 34),
      SizedBox(width: double.infinity, child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: AppColors.success), onPressed: controller.finish, icon: const Icon(Icons.home_rounded), label: const Text('SELESAI'))),
    ])));
  }
}
