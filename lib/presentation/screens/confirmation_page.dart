import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/logic/bloc/confirmation/confirmation_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

class ConfirmationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ConfirmationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ConfirmationBloc(
          authRepository: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _confirmationForm(),
          ],
        ),
      ),
    );
  }

  Widget _confirmationForm() {
    return BlocListener<ConfirmationBloc, ConfirmationState>(
      listener: (context, state) {
        final formSubmissionState = state.formSubmissionState;
        if (formSubmissionState is FormSubmissionFailed) {
          _showExceptionSnackBar(
              context, formSubmissionState.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _codeField(),
              _confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _codeField() {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Código confirmación',
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: whiteColor,
                width: 5.0,
              ),
            ),
          ),
          onChanged: (code) => context.read<ConfirmationBloc>().add(
                ConfirmationCodeChanged(code: code),
              ),
          validator: state.validateCode,
          keyboardType: TextInputType.number,
        );
      },
    );
  }

  Widget _confirmButton() {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
      builder: (context, state) {
        return state.formSubmissionState is FormSubmissionSubmitting
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.read<ConfirmationBloc>().add(
                          ConfirmationSubmitted(),
                        );
                  }
                },
                child: Text('Registrarse'),
              );
      },
    );
  }

  void _showExceptionSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
