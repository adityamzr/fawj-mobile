# Architecture Notes

## State ownership

`PrototypeController` owns all mutable prototype state:

- `role`: pilgrim, responder, or travel admin
- `state`: the requested incident state machine
- `distance`: mock responder distance in meters
- `viewingIncident`: whether the active map is visible
- `emergencyReason`: selected assistance reason

State is intentionally ephemeral and in-memory. `Timer` drives the 3-second dispatch handoff and responder distance steps.

## Screen selection

`PrototypeShell` is a small state router. It renders a feature screen from the current role and incident state without introducing a navigation package. This makes the incident survive role and screen changes while keeping the validation prototype easy to change.

## Safety UX

Emergency red is reserved for SOS and active danger context. Olive and gold provide brand identity but never replace the emergency signal. Every important action combines an icon with text, critical controls are at least 48 logical pixels high, and status meaning is stated in words rather than color alone.
