import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/strings.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/logic/bloc/signup/sign_up_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';
import 'package:spotify_clone/utils/functions.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
          authRepository: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
          dataRepository: context.read<DataRepository>(),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _signUpForm(),
            _signInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _usernameField(),
            _emailField(),
            _passwordField(),
            _signUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: email,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: whiteColor,
                width: 5.0,
              ),
            ),
          ),
          onChanged: (email) => context.read<SignUpBloc>().add(
                SignUpEmailChanged(email: email),
              ),
          validator: state.validateEmail,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            labelText: password,
          ),
          onChanged: (password) => context.read<SignUpBloc>().add(
                SignUpPasswordChanged(password: password),
              ),
          validator: state.validatePassword,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.perm_identity),
            labelText: user,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: whiteColor,
                width: 5.0,
              ),
            ),
          ),
          onChanged: (username) => context.read<SignUpBloc>().add(
                SignUpUsernameChanged(username: username),
              ),
          validator: state.validateUsername,
          keyboardType: TextInputType.name,
        );
      },
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return state.formSubmissionState is FormSubmissionSubmitting
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.read<SignUpBloc>().add(
                          SignUpSubmitted(),
                        );
                  }
                },
                child: Text(sign_up),
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
                text: have_account,
              ),
              TextSpan(
                text: log_in_here,
                style: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
