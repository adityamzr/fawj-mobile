import 'package:fawj_prototype/app/prototype_controller.dart';
import 'package:flutter_test/flutter_test.dart';

PrototypeController fastController() => PrototypeController(
      claimTransitionDelay: Duration.zero,
      redispatchDelay: Duration.zero,
      redispatchIncomingDelay: Duration.zero,
    );

void main() {
  test('primary rescue flow reaches claimed, en route, then resolved', () async {
    final controller = fastController();
    controller.startEmergency();
    controller.chooseEmergency('Saya Tersesat');
    controller.sendRequest();
    controller.chooseViewerRole(ViewerRole.staff);
    controller.claimRequest();

    expect(controller.state, IncidentState.claimed);
    expect(controller.viewerRole, ViewerRole.staff);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(controller.state, IncidentState.enRoute);

    controller.responderArrived();
    expect(controller.viewerRole, ViewerRole.staff);
    controller.chooseViewerRole(ViewerRole.pilgrim);
    controller.confirmMet(true);
    expect(controller.state, IncidentState.resolved);

    controller.finish();
    expect(controller.state, IncidentState.idle);
    controller.dispose();
  });

  test('responder cancel creates a new dispatch cycle', () async {
    final controller = fastController();
    final visited = <IncidentState>[];
    controller.addListener(() => visited.add(controller.state));
    controller.forceState(IncidentState.enRoute);
    controller.cancelResponder();

    expect(controller.state, IncidentState.responderCancelled);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(visited, contains(IncidentState.redispatching));
    expect(controller.state, IncidentState.dispatching);
    controller.dispose();
  });

  test('arrived then BELUM keeps rescue active', () {
    final controller = PrototypeController();
    controller.forceState(IncidentState.arrived);
    controller.confirmMet(false);

    expect(controller.state, IncidentState.nearby);
    expect(controller.distance, 40);
    expect(controller.hasActiveIncident, isTrue);
    controller.dispose();
  });

  test('arrived then YA resolves rescue', () {
    final controller = PrototypeController();
    controller.forceState(IncidentState.arrived);
    controller.confirmMet(true);

    expect(controller.state, IncidentState.resolved);
    expect(controller.hasActiveIncident, isFalse);
    controller.dispose();
  });

  test('selected emergency reason is preserved across role switching', () {
    final controller = PrototypeController();
    controller.startEmergency();
    controller.chooseEmergency('Kondisi Kesehatan / Darurat');
    controller.sendRequest();
    controller.chooseViewerRole(ViewerRole.staff);

    expect(controller.emergencyReason, 'Kondisi Kesehatan / Darurat');
    controller.dispose();
  });

  test('no responder retry returns to dispatching', () {
    final controller = PrototypeController();
    controller.forceState(IncidentState.noResponder);
    controller.retryDispatch();

    expect(controller.state, IncidentState.dispatching);
    expect(controller.hasActiveIncident, isTrue);
    controller.dispose();
  });

  test('normal navigation does not reset an active incident', () {
    final controller = PrototypeController();
    controller.forceState(IncidentState.enRoute);
    controller.selectNavigation(2);

    expect(controller.state, IncidentState.enRoute);
    expect(controller.viewingIncident, isFalse);
    expect(controller.hasActiveIncident, isTrue);
    controller.openIncident();
    expect(controller.state, IncidentState.enRoute);
    controller.dispose();
  });

  test('claim lost returns responder safely to Staff Dashboard', () {
    final controller = PrototypeController();
    controller.chooseViewerRole(ViewerRole.staff);
    controller.forceState(IncidentState.claimLost);
    controller.dismissClaimLost();

    expect(controller.viewerRole, ViewerRole.staff);
    expect(controller.state, IncidentState.idle);
    expect(controller.staffNavigationIndex, 0);
    expect(controller.viewingIncident, isFalse);
    controller.dispose();
  });

  test('Prototype Tools role switching does not mutate incident state', () {
    final controller = PrototypeController();
    controller.forceState(IncidentState.nearby);
    controller.chooseViewerRole(ViewerRole.staff);

    expect(controller.viewerRole, ViewerRole.staff);
    expect(controller.state, IncidentState.nearby);
    controller.chooseViewerRole(ViewerRole.pilgrim);
    expect(controller.state, IncidentState.nearby);
    controller.dispose();
  });
}
