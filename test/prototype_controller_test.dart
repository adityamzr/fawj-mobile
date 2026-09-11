import 'package:flutter_test/flutter_test.dart';
import 'package:fawj_prototype/app/prototype_controller.dart';

void main() {
  test('primary rescue flow reaches resolved then resets', () {
    final controller = PrototypeController();
    controller.startEmergency();
    controller.chooseEmergency('Saya Tersesat');
    controller.sendRequest();
    controller.claimRequest();
    controller.responderArrived();
    controller.confirmMet(true);

    expect(controller.state, IncidentState.resolved);
    controller.finish();
    expect(controller.state, IncidentState.idle);
    expect(controller.role, PrototypeRole.pilgrim);
    controller.dispose();
  });

  test('claim lost and no responder branches can be forced', () {
    final controller = PrototypeController();
    controller.forceState(IncidentState.claimLost);
    expect(controller.state, IncidentState.claimLost);
    controller.forceState(IncidentState.noResponder);
    expect(controller.state, IncidentState.noResponder);
    controller.dispose();
  });
}
