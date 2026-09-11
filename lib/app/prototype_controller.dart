import 'dart:async';

import 'package:flutter/foundation.dart';

enum PrototypeRole { pilgrim, responder, travelAdmin }

enum IncidentState {
  idle,
  selectingEmergency,
  confirming,
  dispatching,
  claimed,
  enRoute,
  nearby,
  arrived,
  resolved,
  claimLost,
  noResponder,
  responderCancelled,
  redispatching,
  offline,
  poorLocationAccuracy,
}

class PrototypeController extends ChangeNotifier {
  PrototypeRole role = PrototypeRole.pilgrim;
  IncidentState state = IncidentState.idle;
  String emergencyReason = 'Saya tersesat';
  int distance = 320;
  bool viewingIncident = true;
  Timer? _timer;

  bool get hasActiveIncident => !{
        IncidentState.idle,
        IncidentState.selectingEmergency,
        IncidentState.confirming,
        IncidentState.resolved,
        IncidentState.claimLost,
      }.contains(state);

  void chooseRole(PrototypeRole value) {
    role = value;
    notifyListeners();
  }

  void startEmergency() {
    state = IncidentState.selectingEmergency;
    notifyListeners();
  }

  void chooseEmergency(String value) {
    emergencyReason = value;
    state = IncidentState.confirming;
    notifyListeners();
  }

  void cancelConfirmation() {
    state = IncidentState.selectingEmergency;
    notifyListeners();
  }

  void sendRequest() {
    state = IncidentState.dispatching;
    viewingIncident = true;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (state == IncidentState.dispatching) {
        role = PrototypeRole.responder;
        notifyListeners();
      }
    });
  }

  void claimRequest({bool loseClaim = false}) {
    if (loseClaim) {
      state = IncidentState.claimLost;
      notifyListeners();
      return;
    }
    state = IncidentState.enRoute;
    distance = 320;
    viewingIncident = true;
    notifyListeners();
    _startMovement();
  }

  void _startMovement() {
    const steps = [240, 160, 90, 40];
    var index = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (index >= steps.length || !{IncidentState.enRoute, IncidentState.nearby}.contains(state)) {
        timer.cancel();
        return;
      }
      distance = steps[index++];
      state = distance <= 100 ? IncidentState.nearby : IncidentState.enRoute;
      notifyListeners();
    });
  }

  void responderArrived() {
    _timer?.cancel();
    state = IncidentState.arrived;
    role = PrototypeRole.pilgrim;
    viewingIncident = true;
    notifyListeners();
  }

  void confirmMet(bool met) {
    if (met) {
      state = IncidentState.resolved;
    } else {
      state = IncidentState.nearby;
      distance = 40;
    }
    notifyListeners();
  }

  void finish() {
    _timer?.cancel();
    state = IncidentState.idle;
    role = PrototypeRole.pilgrim;
    distance = 320;
    viewingIncident = true;
    notifyListeners();
  }

  void cancelResponder() {
    _timer?.cancel();
    state = IncidentState.responderCancelled;
    role = PrototypeRole.pilgrim;
    notifyListeners();
    _timer = Timer(const Duration(seconds: 2), () {
      if (state == IncidentState.responderCancelled) {
        state = IncidentState.redispatching;
        notifyListeners();
        _timer = Timer(const Duration(seconds: 3), () {
          if (state == IncidentState.redispatching) {
            state = IncidentState.enRoute;
            distance = 320;
            notifyListeners();
            _startMovement();
          }
        });
      }
    });
  }

  void retryDispatch() {
    state = IncidentState.dispatching;
    notifyListeners();
  }

  void toggleIncidentView() {
    viewingIncident = !viewingIncident;
    notifyListeners();
  }

  void forceState(IncidentState value) {
    _timer?.cancel();
    state = value;
    if (value == IncidentState.nearby) distance = 90;
    if (value == IncidentState.enRoute || value == IncidentState.claimed) distance = 320;
    if (value == IncidentState.arrived || value == IncidentState.resolved) viewingIncident = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
