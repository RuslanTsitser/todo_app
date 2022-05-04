import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/state/auth/auth_bloc.dart';
import '../properties/elevated_button_style.dart';
import '../properties/text_field_decoration.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

    Widget _usernameField() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        controller: _usernameController,
        decoration:
            textFieldDecoration('Введите username', _usernameController),
      );
    }

    Widget _passwordField() {
      return TextFormField(
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        controller: _passwordController,
        decoration:
            textFieldDecoration('Введите password', _passwordController),
      );
    }

    Widget _loginButton() {
      return ElevatedButton(
        style: elevatedButtonStyle(context),
        onPressed: () {
          context.read<AuthBloc>().add(
                LoginWithUsername(
                  _usernameController.text,
                  _passwordController.text,
                ),
              );
        },
        child: Text(
          'Войти',
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 150,
            ),
            const SizedBox(height: 16),
            _usernameField(),
            const SizedBox(height: 16),
            _passwordField(),
            const SizedBox(height: 16),
            _loginButton(),
          ],
        ),
      ),
    );
  }
}
