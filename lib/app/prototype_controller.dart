import 'dart:async';

import 'package:flutter/foundation.dart';

enum ViewerRole { pilgrim, staff }

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

/// Local UX simulation only.
///
/// Production must model incident state, viewer role, connectivity state, and
/// location quality independently. This compact enum must not be copied into
/// production domain logic.
class PrototypeController extends ChangeNotifier {
  PrototypeController({
    this.claimTransitionDelay = const Duration(milliseconds: 700),
    this.redispatchDelay = const Duration(milliseconds: 900),
    this.redispatchIncomingDelay = const Duration(seconds: 2),
  });

  final Duration claimTransitionDelay;
  final Duration redispatchDelay;
  final Duration redispatchIncomingDelay;

  ViewerRole viewerRole = ViewerRole.pilgrim;
  IncidentState state = IncidentState.idle;
  String emergencyReason = 'Saya Tersesat';
  int distance = 320;
  bool viewingIncident = true;
  bool previewingTravelWebDashboard = false;
  int pilgrimNavigationIndex = 0;
  int staffNavigationIndex = 0;
  Timer? _timer;

  bool get hasActiveIncident => !{
        IncidentState.idle,
        IncidentState.selectingEmergency,
        IncidentState.confirming,
        IncidentState.resolved,
        IncidentState.claimLost,
      }.contains(state);

  int get navigationIndex => viewerRole == ViewerRole.pilgrim
      ? pilgrimNavigationIndex
      : staffNavigationIndex;

  void chooseViewerRole(ViewerRole value) {
    viewerRole = value;
    previewingTravelWebDashboard = false;
    viewingIncident = true;
    notifyListeners();
  }

  void selectNavigation(int index) {
    if (viewerRole == ViewerRole.pilgrim) {
      pilgrimNavigationIndex = index;
    } else {
      staffNavigationIndex = index;
    }
    viewingIncident = false;
    notifyListeners();
  }

  void previewTravelWebDashboard() {
    previewingTravelWebDashboard = true;
    notifyListeners();
  }

  void closeTravelWebDashboard() {
    previewingTravelWebDashboard = false;
    notifyListeners();
  }

  void startEmergency() {
    state = IncidentState.selectingEmergency;
    viewingIncident = true;
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
    _timer?.cancel();
    state = IncidentState.dispatching;
    viewingIncident = true;
    notifyListeners();
  }

  void claimRequest({bool loseClaim = false}) {
    _timer?.cancel();
    if (loseClaim) {
      state = IncidentState.claimLost;
      notifyListeners();
      return;
    }

    state = IncidentState.claimed;
    distance = 320;
    viewingIncident = true;
    notifyListeners();
    _timer = Timer(claimTransitionDelay, () {
      if (state != IncidentState.claimed) return;
      state = IncidentState.enRoute;
      notifyListeners();
      _startMovement();
    });
  }

  void _startMovement() {
    const steps = [240, 160, 90, 40];
    var index = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (index >= steps.length ||
          !{IncidentState.enRoute, IncidentState.nearby}.contains(state)) {
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
    viewingIncident = viewerRole == ViewerRole.pilgrim;
    notifyListeners();
  }

  void confirmMet(bool met) {
    if (met) {
      state = IncidentState.resolved;
    } else {
      state = IncidentState.nearby;
      distance = 40;
      viewingIncident = true;
    }
    notifyListeners();
  }

  void finish() {
    _timer?.cancel();
    state = IncidentState.idle;
    distance = 320;
    viewingIncident = false;
    previewingTravelWebDashboard = false;
    pilgrimNavigationIndex = 0;
    staffNavigationIndex = 0;
    notifyListeners();
  }

  void cancelResponder() {
    _timer?.cancel();
    state = IncidentState.responderCancelled;
    viewingIncident = true;
    notifyListeners();
    _timer = Timer(redispatchDelay, () {
      if (state != IncidentState.responderCancelled) return;
      state = IncidentState.redispatching;
      notifyListeners();
      _timer = Timer(redispatchIncomingDelay, () {
        if (state != IncidentState.redispatching) return;
        state = IncidentState.dispatching;
        distance = 320;
        notifyListeners();
      });
    });
  }

  void retryDispatch() {
    _timer?.cancel();
    state = IncidentState.dispatching;
    viewingIncident = true;
    notifyListeners();
  }

  void openIncident() {
    viewingIncident = true;
    notifyListeners();
  }

  void hideIncident() {
    viewingIncident = false;
    notifyListeners();
  }

  void dismissClaimLost() {
    _timer?.cancel();
    state = IncidentState.idle;
    viewingIncident = false;
    if (viewerRole == ViewerRole.pilgrim) {
      pilgrimNavigationIndex = 0;
    } else {
      staffNavigationIndex = 0;
    }
    notifyListeners();
  }

  void forceState(IncidentState value) {
    _timer?.cancel();
    state = value;
    viewingIncident = true;
    previewingTravelWebDashboard = false;
    if (value == IncidentState.nearby) distance = 90;
    if (value == IncidentState.enRoute ||
        value == IncidentState.claimed ||
        value == IncidentState.dispatching) {
      distance = 320;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
