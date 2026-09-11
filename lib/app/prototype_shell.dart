import 'package:flutter/material.dart';

import '../core/mock/mock_data.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          body: Column(children: [
            if (controller.hasActiveIncident && !controller.viewingIncident)
              StatusBanner(
                title: controller.role == PrototypeRole.responder ? 'Rescue aktif' : 'Bantuan sedang berlangsung',
                message: controller.role == PrototypeRole.responder ? 'Ahmad · ${controller.distance} m' : '${MockData.responder} menuju Anda',
                action: controller.role == PrototypeRole.responder ? 'KEMBALI KE MAP' : 'LIHAT MAP',
                onTap: controller.toggleIncidentView,
              ),
            Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: KeyedSubtree(key: ValueKey('${controller.role}-${controller.state}-${controller.viewingIncident}'), child: _screen()))),
          ]),
          floatingActionButton: null,
          extendBody: true,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: _roleNavigation(),
          drawerScrimColor: Colors.black38,
        );
      },
    );
  }

  Widget _screen() {
    if (controller.role == PrototypeRole.travelAdmin) return const TravelAdminScreen();

    if (!controller.viewingIncident && controller.role == PrototypeRole.pilgrim) return PilgrimHomeScreen(controller: controller);
    if (!controller.viewingIncident && controller.role == PrototypeRole.responder) return StaffDashboardScreen(controller: controller);

    if (controller.state == IncidentState.selectingEmergency || controller.state == IncidentState.confirming) {
      return EmergencyTypeScreen(controller: controller);
    }
    if (controller.state == IncidentState.arrived) return ArrivalScreen(controller: controller);
    if (controller.state == IncidentState.resolved) return ResolvedScreen(controller: controller);
    if ({IncidentState.noResponder, IncidentState.offline, IncidentState.poorLocationAccuracy, IncidentState.claimLost}.contains(controller.state)) {
      return ExceptionStateScreen(controller: controller, state: controller.state);
    }
    if ({IncidentState.responderCancelled, IncidentState.redispatching}.contains(controller.state)) {
      return SearchingScreen(controller: controller);
    }
    if (controller.role == PrototypeRole.pilgrim) {
      if (controller.state == IncidentState.dispatching) return SearchingScreen(controller: controller);
      if ({IncidentState.claimed, IncidentState.enRoute, IncidentState.nearby}.contains(controller.state)) return RescueMapScreen(controller: controller, responderView: false);
      return PilgrimHomeScreen(controller: controller);
    }
    if (controller.role == PrototypeRole.responder) {
      if (controller.state == IncidentState.dispatching || controller.state == IncidentState.claimed) return IncomingSosScreen(controller: controller);
      if ({IncidentState.enRoute, IncidentState.nearby}.contains(controller.state)) return RescueMapScreen(controller: controller, responderView: true);
      return StaffDashboardScreen(controller: controller);
    }
    return PilgrimHomeScreen(controller: controller);
  }

  Widget _roleNavigation() {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 68,
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 58,
              margin: const EdgeInsets.fromLTRB(14, 0, 76, 8),
              decoration: BoxDecoration(color: ThemeData.light().colorScheme.surface, borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 18)]),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _RoleButton(icon: Icons.person_rounded, label: 'Jamaah', selected: controller.role == PrototypeRole.pilgrim, onTap: () => controller.chooseRole(PrototypeRole.pilgrim)),
                _RoleButton(icon: Icons.badge_rounded, label: 'Staff', selected: controller.role == PrototypeRole.responder, onTap: () => controller.chooseRole(PrototypeRole.responder)),
                _RoleButton(icon: Icons.dashboard_rounded, label: 'Travel', selected: controller.role == PrototypeRole.travelAdmin, onTap: () => controller.chooseRole(PrototypeRole.travelAdmin)),
              ]),
            ),
          ),
          DebugPanelButton(controller: controller),
        ]),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: 'Mode $label',
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 21, color: selected ? const Color(0xFF3A4428) : Colors.grey), Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: selected ? const Color(0xFF3A4428) : Colors.grey))]),
      ),
    ),
  );
}
