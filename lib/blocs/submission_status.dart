abstract class SubmissionStatus {
  const SubmissionStatus();
}

class InitialStatus extends SubmissionStatus {
  const InitialStatus();
}

class Submitting extends SubmissionStatus {}

class Success extends SubmissionStatus {}

class Failed extends SubmissionStatus {
  final Exception exception;
  Failed({required this.exception});
}
