import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/logic/bloc/login/login_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository authRepository;

  LoginPage({Key key, @required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepository: authRepository,
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _loginForm(),
            _signUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
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
              _emailField(),
              _passwordField(),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
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
          onChanged: (email) => context.read<LoginBloc>().add(
                LoginEmailChanged(email: email),
              ),
          validator: state.validateEmail,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            labelText: 'Contraseña',
          ),
          onChanged: (password) => context.read<LoginBloc>().add(
                LoginPasswordChanged(password: password),
              ),
          validator: state.validatePassword,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.formSubmissionState is FormSubmissionSubmitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.read<LoginBloc>().add(
                          LoginSubmitted(),
                        );
                  }
                },
                child: Text('Iniciar sesión'),
              );
      },
    );
  }

  Widget _signUpButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
          onPressed: () {
            context.read<AuthCubit>().showSignUp();
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
          )),
    );
  }

  void _showExceptionSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
