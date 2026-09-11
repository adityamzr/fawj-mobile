import 'package:flutter/material.dart';

import '../core/mock/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/status_banner.dart';
import '../features/emergency/emergency_type_screen.dart';
import '../features/pilgrim_home/pilgrim_home_screen.dart';
import '../features/rescue/arrival_screen.dart';
import '../features/rescue/exception_state_screen.dart';
import '../features/rescue/rescue_map_screen.dart';
import '../features/rescue/searching_screen.dart';
import '../features/responder/incoming_sos_screen.dart';
import '../features/staff/staff_dashboard_screen.dart';
import '../features/travel_demo/travel_admin_screen.dart';
import 'debug_panel.dart';
import 'prototype_controller.dart';

class PrototypeShell extends StatelessWidget {
  const PrototypeShell({super.key, required this.controller});
  final PrototypeController controller;

  static const pilgrimDestinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Beranda'),
    NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Peta'),
    NavigationDestination(icon: Icon(Icons.luggage_outlined), selectedIcon: Icon(Icons.luggage_rounded), label: 'Perjalanan'),
    NavigationDestination(icon: Icon(Icons.help_outline_rounded), selectedIcon: Icon(Icons.help_rounded), label: 'Bantuan'),
    NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Akun'),
  ];

  static const staffDestinations = [
    NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
    NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map_rounded), label: 'Peta'),
    NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups_rounded), label: 'Jamaah'),
    NavigationDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check_rounded), label: 'Operasional'),
    NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Akun'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final previewingWeb = controller.previewingTravelWebDashboard;
        return Scaffold(
          body: Column(children: [
            if (controller.hasActiveIncident && !controller.viewingIncident && !previewingWeb)
              StatusBanner(
                title: controller.viewerRole == ViewerRole.staff
                    ? 'Rescue aktif'
                    : 'Bantuan sedang berlangsung',
                message: controller.viewerRole == ViewerRole.staff
                    ? '${MockData.pilgrimShort} · ${controller.distance} m'
                    : '${MockData.responder} menuju Anda',
                action: controller.viewerRole == ViewerRole.staff
                    ? 'KEMBALI KE MAP'
                    : 'LIHAT MAP',
                onTap: controller.openIncident,
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(
                    '${controller.viewerRole}-${controller.state}-${controller.viewingIncident}-${controller.navigationIndex}-$previewingWeb',
                  ),
                  child: _screen(),
                ),
              ),
            ),
          ]),
          floatingActionButton: DebugPanelButton(controller: controller),
          bottomNavigationBar: previewingWeb ? null : _productNavigation(),
          resizeToAvoidBottomInset: true,
        );
      },
    );
  }

  Widget _screen() {
    if (controller.previewingTravelWebDashboard) {
      return TravelAdminScreen(onClose: controller.closeTravelWebDashboard);
    }

    if (!controller.viewingIncident) return _productScreen();

    if ({IncidentState.selectingEmergency, IncidentState.confirming}
        .contains(controller.state)) {
      return EmergencyTypeScreen(controller: controller);
    }

    if (controller.viewerRole == ViewerRole.pilgrim) {
      return _pilgrimIncidentScreen();
    }
    return _staffIncidentScreen();
  }

  Widget _pilgrimIncidentScreen() {
    if (controller.state == IncidentState.arrived) {
      return ArrivalScreen(controller: controller);
    }
    if (controller.state == IncidentState.resolved) {
      return ResolvedScreen(controller: controller);
    }
    if ({
      IncidentState.noResponder,
      IncidentState.offline,
      IncidentState.poorLocationAccuracy,
      IncidentState.claimLost,
    }.contains(controller.state)) {
      return ExceptionStateScreen(controller: controller, state: controller.state);
    }
    if ({
      IncidentState.dispatching,
      IncidentState.responderCancelled,
      IncidentState.redispatching,
    }.contains(controller.state)) {
      return SearchingScreen(controller: controller);
    }
    if ({IncidentState.claimed, IncidentState.enRoute, IncidentState.nearby}
        .contains(controller.state)) {
      return RescueMapScreen(controller: controller, responderView: false);
    }
    return _productScreen();
  }

  Widget _staffIncidentScreen() {
    if (controller.state == IncidentState.claimLost) {
      return ExceptionStateScreen(controller: controller, state: controller.state);
    }
    if ({IncidentState.dispatching, IncidentState.claimed}
        .contains(controller.state)) {
      return IncomingSosScreen(controller: controller);
    }
    if ({IncidentState.enRoute, IncidentState.nearby}
        .contains(controller.state)) {
      return RescueMapScreen(controller: controller, responderView: true);
    }
    if ({IncidentState.responderCancelled, IncidentState.redispatching}
        .contains(controller.state)) {
      return SearchingScreen(controller: controller);
    }
    if (controller.state == IncidentState.arrived) {
      return const _PlaceholderScreen(
        icon: Icons.hourglass_top_rounded,
        title: 'Menunggu konfirmasi jamaah',
        message: 'Jamaah perlu mengonfirmasi bahwa pendamping sudah ditemukan.',
      );
    }
    if ({
      IncidentState.noResponder,
      IncidentState.offline,
      IncidentState.poorLocationAccuracy,
    }.contains(controller.state)) {
      return ExceptionStateScreen(controller: controller, state: controller.state);
    }
    return _productScreen();
  }

  Widget _productScreen() {
    final index = controller.navigationIndex;
    if (controller.viewerRole == ViewerRole.pilgrim) {
      if (index == 0) return PilgrimHomeScreen(controller: controller);
      const data = [
        (Icons.map_rounded, 'Peta', 'Peta rombongan akan tersedia pada pengembangan berikutnya.'),
        (Icons.luggage_rounded, 'Perjalanan', 'Detail perjalanan ini masih berupa placeholder prototype.'),
        (Icons.help_rounded, 'Bantuan', 'Pusat bantuan akan dikembangkan setelah alur SOS tervalidasi.'),
        (Icons.person_rounded, 'Akun', 'Pengaturan akun masih berupa placeholder prototype.'),
      ];
      final item = data[index - 1];
      return _PlaceholderScreen(icon: item.$1, title: item.$2, message: item.$3);
    }

    if (index == 0) return StaffDashboardScreen(controller: controller);
    const data = [
      (Icons.map_rounded, 'Peta', 'Peta operasional staff masih berupa placeholder prototype.'),
      (Icons.groups_rounded, 'Jamaah', 'Daftar jamaah akan dikembangkan pada tahap berikutnya.'),
      (Icons.fact_check_rounded, 'Operasional', 'Fitur operasional masih berupa placeholder prototype.'),
      (Icons.person_rounded, 'Akun', 'Pengaturan akun staff masih berupa placeholder prototype.'),
    ];
    final item = data[index - 1];
    return _PlaceholderScreen(icon: item.$1, title: item.$2, message: item.$3);
  }

  Widget _productNavigation() {
    final pilgrim = controller.viewerRole == ViewerRole.pilgrim;
    return NavigationBar(
      selectedIndex: controller.navigationIndex,
      onDestinationSelected: controller.selectNavigation,
      destinations: pilgrim ? pilgrimDestinations : staffDestinations,
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: .22),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.olive),
            ),
            const SizedBox(height: 22),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ]),
        ),
      ),
    );
  }
}
