import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/mock_rescue_map.dart';

class SearchingScreen extends StatelessWidget {
  const SearchingScreen({super.key, required this.controller});
  final PrototypeController controller;

  @override
  Widget build(BuildContext context) {
    final redispatch = {IncidentState.responderCancelled, IncidentState.redispatching}.contains(controller.state);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 90),
        child: Column(children: [
          Container(width: 66, height: 66, decoration: BoxDecoration(color: AppColors.emergency.withValues(alpha: .10), shape: BoxShape.circle), child: const Icon(Icons.travel_explore_rounded, color: AppColors.emergency, size: 34)),
          const SizedBox(height: 18),
          Text(redispatch ? 'Mencari pendamping lain' : 'Permintaan bantuan terkirim', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(redispatch ? 'Kami sedang mencari pendamping lain. Anda tidak perlu membuat permintaan baru.' : 'Kami sedang mencari pendamping yang dapat membantu Anda.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 22),
          const MockRescueMap(distance: 320),
          const SizedBox(height: 15),
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Row(children: [
            Icon(Icons.my_location_rounded, color: AppColors.emergency),
            SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Posisi Anda', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), Text('Tetaplah di lokasi jika aman.', style: TextStyle(fontSize: 15))])),
          ]))),
          const SizedBox(height: 15),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => _demo(context, 'Menghubungi Tour Leader'), icon: const Icon(Icons.call_rounded), label: const Text('Tour Leader'))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(onPressed: () => _demo(context, 'Membuka Kartu Darurat'), icon: const Icon(Icons.badge_rounded), label: const Text('Kartu Darurat'))),
          ]),
          TextButton.icon(onPressed: () => _cancel(context), icon: const Icon(Icons.close_rounded), label: const Text('Batalkan Permintaan')),
        ]),
      ),
    );
  }

  void _demo(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message (demo lokal).')));

  Future<void> _cancel(BuildContext context) async {
    final cancel = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Batalkan permintaan?'), content: const Text('Pendamping tidak lagi menerima permintaan bantuan ini.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('TIDAK')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('YA, BATALKAN'))])) ?? false;
    if (cancel) controller.finish();
  }
}
