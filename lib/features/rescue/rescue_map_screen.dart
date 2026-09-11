import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/mock_rescue_map.dart';

class RescueMapScreen extends StatelessWidget {
  const RescueMapScreen({super.key, required this.controller, required this.responderView});
  final PrototypeController controller;
  final bool responderView;

  @override
  Widget build(BuildContext context) {
    final nearby = controller.distance <= 100;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(responderView ? 'Menuju Jamaah' : (nearby ? 'Penolong sudah dekat' : 'Bantuan sedang menuju Anda'), style: Theme.of(context).textTheme.headlineMedium)),
            PopupMenuButton<String>(
              tooltip: 'Pilihan lainnya',
              onSelected: (value) { if (value == 'hide') controller.hideIncident(); if (value == 'cancel') _cancelResponder(context); },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'hide', child: Text('Tutup tampilan map')),
                if (responderView) const PopupMenuItem(value: 'cancel', child: Text('Tidak dapat melanjutkan')),
              ],
            ),
          ]),
          const SizedBox(height: 16),
          MockRescueMap(distance: controller.distance, responderView: responderView),
          const SizedBox(height: 10),
          const Row(children: [
            Icon(Icons.gps_fixed_rounded, size: 18, color: AppColors.success),
            SizedBox(width: 7),
            Expanded(child: Text('Lokasi cukup akurat · Akurasi sekitar ±15 meter', style: TextStyle(fontSize: 13, color: AppColors.oliveSoft, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(responderView ? MockData.pilgrim : MockData.responder, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(responderView ? 'Group ${MockData.pilgrimGroup}' : '${MockData.responderRole} · Group ${MockData.responderGroup}', style: const TextStyle(fontSize: 15, color: AppColors.oliveSoft)),
                const Divider(height: 28),
                Row(children: [
                  Icon(nearby ? Icons.near_me_rounded : Icons.directions_walk_rounded, color: nearby ? AppColors.warning : AppColors.olive),
                  const SizedBox(width: 10),
                  Expanded(child: Text(nearby ? 'Penolong sudah dekat' : (responderView ? 'Jamaah menunggu di lokasi' : 'Sedang menuju Anda'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  Text('${controller.distance} m', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          if (!responderView)
            const Card(color: Color(0xFFFFF4D8), child: Padding(padding: EdgeInsets.all(16), child: Row(children: [Icon(Icons.shield_rounded, color: AppColors.warning), SizedBox(width: 10), Expanded(child: Text('Tetaplah di lokasi jika aman.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)))]))),
          const SizedBox(height: 14),
          if (responderView) ...[
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _demo(context, 'Navigasi eksternal akan dibuka'), icon: const Icon(Icons.map_rounded), label: const Text('BUKA MAPS'))),
            const SizedBox(height: 10),
          ],
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => _demo(context, 'Panggilan simulasi'), icon: const Icon(Icons.call_rounded), label: const Text('HUBUNGI'))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(onPressed: () => _demo(context, 'Pesan simulasi'), icon: const Icon(Icons.message_rounded), label: const Text('PESAN'))),
          ]),
          if (responderView) ...[
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: AppColors.emergency), onPressed: controller.responderArrived, icon: const Icon(Icons.location_on_rounded), label: const Text('SAYA SUDAH TIBA'))),
          ],
        ]),
      ),
    );
  }

  void _demo(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message (prototype).')));

  Future<void> _cancelResponder(BuildContext context) async {
    final cancel = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Tidak dapat melanjutkan?'), content: const Text('Permintaan akan segera dialihkan ke pendamping lain.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('KEMBALI')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('ALIHKAN'))])) ?? false;
    if (cancel) controller.cancelResponder();
  }
}
