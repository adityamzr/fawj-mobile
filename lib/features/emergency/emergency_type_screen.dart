import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/theme/app_colors.dart';

class EmergencyTypeScreen extends StatelessWidget {
  const EmergencyTypeScreen({super.key, required this.controller});
  final PrototypeController controller;

  static const items = [
    (Icons.wrong_location_rounded, 'Saya Tersesat'),
    (Icons.group_off_rounded, 'Saya Tertinggal Rombongan'),
    (Icons.front_hand_rounded, 'Saya Membutuhkan Bantuan'),
    (Icons.medical_services_rounded, 'Kondisi Kesehatan / Darurat'),
    (Icons.more_horiz_rounded, 'Lainnya'),
  ];

  Future<void> _confirm(BuildContext context, String reason) async {
    controller.chooseEmergency(reason);
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      showDragHandle: false,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.emergency_rounded, size: 42, color: AppColors.emergency),
          const SizedBox(height: 16),
          const Text('Anda akan meminta bantuan karena:', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 9),
          Text(reason.toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.emergency)),
          const SizedBox(height: 12),
          const Text('Lokasi Anda akan dibagikan kepada pendamping yang membantu.', style: TextStyle(fontSize: 16, height: 1.4)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () { controller.cancelConfirmation(); Navigator.pop(context); }, child: const Text('BATAL'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.emergency), onPressed: () { Navigator.pop(context); controller.sendRequest(); }, child: const Text('KIRIM BANTUAN'))),
          ]),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconButton.filledTonal(onPressed: controller.finish, icon: const Icon(Icons.arrow_back_rounded), tooltip: 'Kembali'),
          const SizedBox(height: 18),
          Text('Apa yang terjadi?', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Pilih kondisi yang paling sesuai agar pendamping dapat membantu.', style: TextStyle(fontSize: 16, color: AppColors.oliveSoft)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 11),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _confirm(context, item.$2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                      child: Row(children: [
                        Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.emergency.withValues(alpha: .09), borderRadius: BorderRadius.circular(14)), child: Icon(item.$1, color: AppColors.emergency)),
                        const SizedBox(width: 14),
                        Expanded(child: Text(item.$2, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.oliveSoft),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
