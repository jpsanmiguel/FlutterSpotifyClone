part of 'confirmation_bloc.dart';

class ConfirmationState extends Equatable {
  final String code;
  final FormSubmissionState formSubmissionState;

  ConfirmationState({
    this.code = '',
    this.formSubmissionState = const InitialFormState(),
  });

  ConfirmationState copyWith({
    String code,
    FormSubmissionState formSubmissionState,
  }) {
    return ConfirmationState(
        code: code ?? this.code,
        formSubmissionState: formSubmissionState ?? this.formSubmissionState);
  }

  String validateCode(String code) {
    if (code.length != 6) {
      return 'El código debe ser de 6 caracteres';
    }
    return null;
  }

  @override
  List<Object> get props => [code, formSubmissionState];
}
