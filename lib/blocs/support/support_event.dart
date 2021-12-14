import 'package:sosconnect/models/support.dart';

abstract class SupportEvent {}

class SupportInitialized extends SupportEvent {}

class SupportListReceived extends SupportEvent {
  final List<Support>? supports;
  SupportListReceived({required this.supports});
}

class SupportSelected extends SupportEvent {
  final Support selectedSupport;
  SupportSelected({required this.selectedSupport});
}

class SupportSubmitted extends SupportEvent {
  final String content;
  SupportSubmitted({required this.content});
}

class SupportUpdated extends SupportEvent {
  final int supportId;
  final String content;
  SupportUpdated({required this.supportId, required this.content});
}

class SupportDeleted extends SupportEvent{}
