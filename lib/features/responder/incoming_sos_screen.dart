import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';

class IncomingSosScreen extends StatelessWidget {
  const IncomingSosScreen({super.key, required this.controller});
  final PrototypeController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppColors.emergency, borderRadius: BorderRadius.circular(26), boxShadow: const [BoxShadow(color: Color(0x44C62828), blurRadius: 22, offset: Offset(0, 9))]),
            child: const Column(children: [
              Icon(Icons.emergency_rounded, color: Colors.white, size: 45),
              SizedBox(height: 10),
              Text('JAMAAH MEMBUTUHKAN\nBANTUAN', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
            ]),
          ),
          const Spacer(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(children: [
                const CircleAvatar(radius: 34, backgroundColor: Color(0xFFE8ECDD), child: Icon(Icons.person_rounded, size: 38, color: AppColors.olive)),
                const SizedBox(height: 14),
                Text(MockData.pilgrim, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(controller.emergencyReason, style: const TextStyle(fontSize: 18, color: AppColors.emergency, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.groups_rounded, color: AppColors.oliveSoft, size: 20),
                  const SizedBox(width: 6),
                  const Text('Group ${MockData.pilgrimGroup}', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  const Icon(Icons.route_rounded, color: AppColors.oliveSoft, size: 20),
                  const SizedBox(width: 6),
                  Text('${controller.distance} meter', style: const TextStyle(fontSize: 16)),
                ]),
              ]),
            ),
          ),
          const Spacer(),
          SizedBox(width: double.infinity, child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: AppColors.emergency, minimumSize: const Size(48, 62)), onPressed: controller.state == IncidentState.claimed ? null : controller.claimRequest, icon: Icon(controller.state == IncidentState.claimed ? Icons.check_circle_rounded : Icons.volunteer_activism_rounded), label: Text(controller.state == IncidentState.claimed ? 'PERMINTAAN DIKLAIM' : 'SAYA BANTU', style: const TextStyle(fontSize: 18)))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _detail(context), icon: const Icon(Icons.info_outline_rounded), label: const Text('LIHAT DETAIL'))),
        ]),
      ),
    );
  }

  void _detail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Permintaan', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
            const SizedBox(height: 16),
            const Text('${MockData.pilgrim} · Group ${MockData.pilgrimGroup}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 7),
            Text(
              'Alasan: ${controller.emergencyReason}\nJarak saat ini: ${controller.distance} meter\nLokasi dibagikan untuk keperluan bantuan.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
