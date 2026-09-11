# Architecture Notes

## State ownership

`PrototypeController` owns all mutable prototype state:

- `viewerRole`: pilgrim or field staff; changed only through Prototype Tools
- `state`: the local UX incident simulation
- `distance`: mock responder distance in meters
- `viewingIncident`: whether the active map is visible
- `emergencyReason`: selected assistance reason
- separate bottom-navigation indices for Jamaah and Staff
- whether the presentation-only Travel Web Dashboard Preview is open

State is intentionally ephemeral and in-memory. Timers drive the short `claimed` transition, redispatch cycle, and responder distance steps. Incident transitions never change `viewerRole`.

## Screen selection

`PrototypeShell` is a small state router. It renders a feature screen from the current viewer, product tab, and incident state without introducing a navigation package. This makes the incident survive normal navigation and manual viewer changes while keeping the validation prototype easy to change.

Travel Admin is a web role in the final architecture. Its retained mobile-sized screen is only reachable from Prototype Tools and is clearly labeled as a web dashboard preview.

## Production boundary

The current enum is deliberately compact for UX demonstrations. Production must keep incident state, viewer role, network connectivity, and location quality as independent concepts so combinations such as `enRoute + offline + poor accuracy` can be represented. Do not reuse this prototype state model as production domain logic.

## Safety UX

Emergency red is reserved for SOS and active danger context. Olive and gold provide brand identity but never replace the emergency signal. Every important action combines an icon with text, critical controls are at least 48 logical pixels high, and status meaning is stated in words rather than color alone.
