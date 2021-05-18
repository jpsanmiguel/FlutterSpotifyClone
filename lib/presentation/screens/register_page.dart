import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/auth_repository.dart';
import 'package:spotify_clone/logic/bloc/register/register_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository authRepository;

  RegisterPage({Key key, @required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterBloc(
          authRepository: authRepository,
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _registerForm(),
            _signInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _registerForm() {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        final formSubmissionState = state.formSubmissionState;
        if (formSubmissionState is FormSubmissionFailed) {
          _showExceptionSnackBar(
              context, formSubmissionState.exception.toString());
        } else if (formSubmissionState is FormSubmissionSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _emailField(),
              _passwordField(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: 'Correo',
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: whiteColor,
                width: 5.0,
              ),
            ),
          ),
          onChanged: (email) => context.read<RegisterBloc>().add(
                RegisterEmailChanged(email: email),
              ),
          validator: state.validateEmail,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            labelText: 'Contraseña',
          ),
          onChanged: (password) => context.read<RegisterBloc>().add(
                RegisterPasswordChanged(password: password),
              ),
          validator: state.validatePassword,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }

  Widget _registerButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return state.formSubmissionState is FormSubmissionSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.read<RegisterBloc>().add(
                          RegisterSubmitted(),
                        );
                  }
                },
                child: Text('Registrarse'),
              );
      },
    );
  }

  Widget _signInButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
          onPressed: () {
            context.read<AuthCubit>().showLogin();
          },
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: textColor,
              ),
              children: [
                TextSpan(
                  text: '¿No tienes una cuenta? ',
                ),
                TextSpan(
                  text: 'Regístrate acá',
                  style: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
          // Text('¿No tienes una cuenta? Regístrate acá'),
          ),
    );
  }

  void _showExceptionSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
