abstract class FormSubmissionState {
  const FormSubmissionState();
}

class InitialFormState extends FormSubmissionState {
  const InitialFormState();
}

class FormSubmissionSubmitting extends FormSubmissionState {}

class FormSubmissionSuccess extends FormSubmissionState {}

class FormSubmissionFailed extends FormSubmissionState {
  final Exception exception;

  FormSubmissionFailed(this.exception);
}
