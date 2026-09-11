import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/fawj_brand.dart';

class PilgrimHomeScreen extends StatelessWidget {
  const PilgrimHomeScreen({super.key, required this.controller});

  final PrototypeController controller;

  static const actions = [
    (Icons.groups_rounded, 'Rombongan Saya'),
    (Icons.place_rounded, 'Meeting Point'),
    (Icons.hotel_rounded, 'Hotel'),
    (Icons.directions_bus_rounded, 'Bus'),
    (Icons.call_rounded, 'Kontak'),
    (Icons.badge_rounded, 'Kartu Darurat'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FawjBrand(),
            CircleAvatar(backgroundColor: AppColors.white, child: Icon(Icons.notifications_none_rounded, color: AppColors.olive)),
          ]),
          const SizedBox(height: AppSpacing.lg),
          Text("Assalamu'alaikum,", style: Theme.of(context).textTheme.bodyLarge),
          Text(MockData.pilgrimShort, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 9),
          const Row(children: [
            Icon(Icons.calendar_month_rounded, size: 19, color: AppColors.oliveSoft),
            SizedBox(width: 7),
            Text('${MockData.trip}  ·  Group ${MockData.pilgrimGroup}', style: TextStyle(fontSize: 15, color: AppColors.oliveSoft, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 30),
          Center(
            child: Semantics(
              button: true,
              label: 'Butuh bantuan. Tekan untuk meminta pertolongan.',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: controller.startEmergency,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFD93636), AppColors.emergencyDark]),
                    boxShadow: [BoxShadow(color: Color(0x55C62828), blurRadius: 24, spreadRadius: 3, offset: Offset(0, 10))],
                  ),
                  child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.sos_rounded, color: Colors.white, size: 36),
                    SizedBox(height: 5),
                    Text('BUTUH\nBANTUAN', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21, height: 1.05, letterSpacing: .5)),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Center(child: Text('Tekan jika Anda tersesat atau membutuhkan bantuan', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.oliveSoft))),
          const SizedBox(height: 30),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .92),
            itemBuilder: (context, index) {
              final action = actions[index];
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${action.$2} adalah tampilan demo.'))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(action.$1, color: AppColors.olive, size: 30),
                      const SizedBox(height: 9),
                      Text(action.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.15)),
                    ]),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
