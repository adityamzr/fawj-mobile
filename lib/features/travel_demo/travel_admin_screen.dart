import 'package:flutter/material.dart';

import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/fawj_brand.dart';

class TravelAdminScreen extends StatelessWidget {
  const TravelAdminScreen({super.key});

  static const stats = [
    (Icons.groups_rounded, 'Jamaah', '186'),
    (Icons.grid_view_rounded, 'Group', '4'),
    (Icons.badge_rounded, 'Staff', '12'),
    (Icons.emergency_rounded, 'SOS Aktif', '1'),
    (Icons.confirmation_number_rounded, 'Kuota', '300'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const FawjBrand(),
      const SizedBox(height: 26),
      Text('Dashboard Travel', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 6),
      const Text(MockData.trip, style: TextStyle(fontSize: 17, color: AppColors.oliveSoft, fontWeight: FontWeight.w600)),
      const SizedBox(height: 22),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 11, mainAxisSpacing: 11, childAspectRatio: 1.55),
        itemBuilder: (context, index) { final item = stats[index]; final danger = item.$2 == 'SOS Aktif'; return Card(color: danger ? AppColors.emergency : AppColors.white, child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [Icon(item.$1, color: danger ? Colors.white : AppColors.olive, size: 29), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(item.$3, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: danger ? Colors.white : AppColors.ink)), Text(item.$2, style: TextStyle(fontSize: 14, color: danger ? Colors.white : AppColors.oliveSoft, fontWeight: FontWeight.w700))])]))); },
      ),
      const SizedBox(height: 24),
      Text('Incident Aktif', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.emergency_rounded, color: AppColors.emergency), SizedBox(width: 9), Text(MockData.pilgrim, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), Spacer(), Chip(label: Text('EN ROUTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), backgroundColor: AppColors.emergency, side: BorderSide.none)]),
        const Divider(height: 28),
        const _Detail(label: 'Group', value: MockData.pilgrimGroup),
        const _Detail(label: 'Responder', value: MockData.responder),
        const _Detail(label: 'Jarak', value: '320 m'),
        const _Detail(label: 'Durasi', value: '4 m 21 d'),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Detail incident adalah tampilan demo.'))), icon: const Icon(Icons.map_rounded), label: const Text('LIHAT INCIDENT'))),
      ]))),
      const SizedBox(height: 12),
      const Text('Demo mobile untuk gambaran dashboard Nuxt di masa mendatang.', style: TextStyle(fontSize: 14, color: AppColors.oliveSoft)),
    ])));
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [SizedBox(width: 105, child: Text(label, style: const TextStyle(color: AppColors.oliveSoft, fontSize: 15))), Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)))]));
}
