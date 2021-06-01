import 'package:equatable/equatable.dart';

abstract class FormSubmissionState extends Equatable {
  const FormSubmissionState();
}

class InitialFormState extends FormSubmissionState {
  const InitialFormState();

  @override
  List<Object> get props => [];
}

class FormSubmissionSubmitting extends FormSubmissionState {
  @override
  List<Object> get props => [];
}

class FormSubmissionSuccess extends FormSubmissionState {
  @override
  List<Object> get props => [];
}

class FormSubmissionFailed extends FormSubmissionState {
  @override
  List<Object> get props => [];
}
