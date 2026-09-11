import 'package:flutter/material.dart';

import '../../app/prototype_controller.dart';
import '../../core/theme/app_colors.dart';

class ExceptionStateScreen extends StatelessWidget {
  const ExceptionStateScreen({super.key, required this.controller, required this.state});
  final PrototypeController controller;
  final IncidentState state;

  @override
  Widget build(BuildContext context) {
    final data = switch (state) {
      IncidentState.noResponder => (Icons.support_agent_rounded, 'Belum ada pendamping', 'Kami belum menemukan pendamping yang dapat menuju Anda.'),
      IncidentState.offline => (Icons.wifi_off_rounded, 'Koneksi internet terputus', 'Lokasi terakhir: 13:22\nKami akan memperbarui lokasi ketika koneksi kembali tersedia.'),
      IncidentState.poorLocationAccuracy => (Icons.gps_off_rounded, 'Lokasi kurang akurat', 'Akurasi sekitar ±85 meter\nPindahlah ke area terbuka jika aman.'),
      IncidentState.claimLost => (Icons.info_rounded, 'Permintaan sudah ditangani', 'Permintaan sudah ditangani oleh petugas lain.'),
      _ => (Icons.sync_rounded, 'Mencari pendamping lain', 'Permintaan Anda tetap aktif. Mohon tetap di lokasi jika aman.'),
    };
    final warning = state == IncidentState.poorLocationAccuracy || state == IncidentState.offline;
    return SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 92, height: 92, decoration: BoxDecoration(color: (warning ? AppColors.warning : AppColors.emergency).withValues(alpha: .13), shape: BoxShape.circle), child: Icon(data.$1, size: 48, color: warning ? const Color(0xFF9A6500) : AppColors.emergency)),
      const SizedBox(height: 26),
      Text(data.$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12),
      Text(data.$3, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 28),
      if (state == IncidentState.noResponder) ...[
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _demo(context, 'Menghubungi Tour Leader'), icon: const Icon(Icons.call_rounded), label: const Text('HUBUNGI TOUR LEADER'))),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _demo(context, 'Membuka Kartu Darurat'), icon: const Icon(Icons.badge_rounded), label: const Text('KARTU DARURAT'))),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: controller.retryDispatch, icon: const Icon(Icons.refresh_rounded), label: const Text('COBA LAGI'))),
      ] else
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: state == IncidentState.claimLost ? controller.dismissClaimLost : () => controller.forceState(IncidentState.enRoute), icon: const Icon(Icons.arrow_forward_rounded), label: Text(state == IncidentState.claimLost ? (controller.viewerRole == ViewerRole.staff ? 'KEMBALI KE DASHBOARD' : 'KEMBALI KE BERANDA') : 'LANJUTKAN DEMO'))),
    ])));
  }

  void _demo(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message (demo lokal).')));
}
