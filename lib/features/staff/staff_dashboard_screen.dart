import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/fawj_brand.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key, required this.controller});
  final PrototypeController controller;

  static const cards = [
    (Icons.groups_rounded, 'Jamaah Saya'),
    (Icons.map_rounded, 'Peta Group'),
    (Icons.place_rounded, 'Meeting Point'),
    (Icons.directions_bus_rounded, 'Lokasi Bus'),
    (Icons.fact_check_rounded, 'Check-in'),
    (Icons.campaign_rounded, 'Pengumuman'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [FawjBrand(), CircleAvatar(backgroundColor: AppColors.white, child: Icon(Icons.person_rounded, color: AppColors.olive))]),
      if (controller.hasActiveIncident) ...[
        const SizedBox(height: 20),
        Card(
          color: AppColors.emergency,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: controller.toggleIncidentView,
            child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
              const Icon(Icons.emergency_rounded, color: Colors.white, size: 34),
              const SizedBox(width: 13),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('1 SOS AKTIF', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)), Text('${MockData.pilgrim} · 320 m', style: TextStyle(color: Colors.white, fontSize: 15))])),
              TextButton(onPressed: controller.toggleIncidentView, child: const Text('LIHAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
            ])),
          ),
        ),
      ],
      const SizedBox(height: 26),
      Text("Assalamu'alaikum,", style: Theme.of(context).textTheme.bodyLarge),
      Text(MockData.responder, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12),
      const Text('${MockData.trip}  ·  Group ${MockData.responderGroup}', style: TextStyle(fontSize: 16, color: AppColors.oliveSoft, fontWeight: FontWeight.w600)),
      const SizedBox(height: 7),
      const Row(children: [Icon(Icons.groups_rounded, size: 20, color: AppColors.olive), SizedBox(width: 7), Text('45 Jamaah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]),
      const SizedBox(height: 26),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.35),
        itemBuilder: (context, index) { final item = cards[index]; return Card(child: InkWell(borderRadius: BorderRadius.circular(22), onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.$2} adalah tampilan demo.'))), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Icon(item.$1, color: AppColors.olive, size: 30), const SizedBox(height: 10), Text(item.$2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))])))); },
      ),
    ])));
  }
}
