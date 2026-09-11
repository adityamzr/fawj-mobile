import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'prototype_controller.dart';

class DebugPanelButton extends StatelessWidget {
  const DebugPanelButton({super.key, required this.controller});
  final PrototypeController controller;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    return FloatingActionButton.small(
      heroTag: 'debug-panel',
      backgroundColor: AppColors.ink.withValues(alpha: .88),
      foregroundColor: Colors.white,
      tooltip: 'Prototype Tools',
      onPressed: () => _show(context),
      child: const Text(
        'DEV',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }

  void _show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.construction_rounded, color: AppColors.olive),
              SizedBox(width: 9),
              Text('Prototype Tools', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 5),
            const Text('Khusus pengembangan dan pengujian. Bukan bagian UI pengguna.', style: TextStyle(color: AppColors.oliveSoft)),
            const SizedBox(height: 18),
            const Text('Viewer role', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<ViewerRole>(
              segments: const [
                ButtonSegment(value: ViewerRole.pilgrim, label: Text('Jamaah'), icon: Icon(Icons.person_rounded)),
                ButtonSegment(value: ViewerRole.staff, label: Text('Staff'), icon: Icon(Icons.badge_rounded)),
              ],
              selected: {controller.viewerRole},
              onSelectionChanged: (value) {
                controller.chooseViewerRole(value.first);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 22),
            const Text('Paksa state', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: IncidentState.values.map((state) => ActionChip(
                avatar: state == controller.state ? const Icon(Icons.check_rounded, size: 18) : null,
                label: Text(_label(state)),
                onPressed: () { controller.forceState(state); Navigator.pop(context); },
              )).toList(),
            ),
            const SizedBox(height: 22),
            const Text('Web role preview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  controller.previewTravelWebDashboard();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.desktop_windows_rounded),
                label: const Text('PREVIEW TRAVEL WEB DASHBOARD'),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () { controller.finish(); Navigator.pop(context); }, icon: const Icon(Icons.restart_alt_rounded), label: const Text('RESET PROTOTYPE'))),
          ]),
        ),
      ),
    );
  }

  String _label(IncidentState state) => switch (state) {
    IncidentState.idle => 'Idle',
    IncidentState.selectingEmergency => 'Pilih SOS',
    IncidentState.confirming => 'Konfirmasi',
    IncidentState.dispatching => 'Searching',
    IncidentState.claimed => 'Claimed',
    IncidentState.enRoute => 'En Route',
    IncidentState.nearby => 'Nearby',
    IncidentState.arrived => 'Arrived',
    IncidentState.resolved => 'Resolved',
    IncidentState.claimLost => 'Claim Lost',
    IncidentState.noResponder => 'No Responder',
    IncidentState.responderCancelled => 'Responder Cancelled',
    IncidentState.redispatching => 'Redispatching',
    IncidentState.offline => 'Offline',
    IncidentState.poorLocationAccuracy => 'Poor Accuracy',
  };
}
