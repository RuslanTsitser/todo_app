import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/internal/providers/providers.dart';
import 'package:todo_app/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/properties/elevated_button_style.dart';
import 'package:todo_app/presentation/properties/text_field_decoration.dart';

import '../../domain/state/auth/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _passwordFocus = FocusNode();

    Widget _usernameField() {
      return ConstrainedBox(
        constraints: BoxConstraints.loose(const Size(500, 150)),
        child: TextFormField(
          onFieldSubmitted: (value) {
            _passwordFocus.requestFocus();
          },
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          controller: _usernameController,
          decoration:
              textFieldDecoration('Введите username', _usernameController),
        ),
      );
    }

    Widget _passwordField() {
      Widget _passwordFieldUI(Function() onSubmit) {
        return ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(500, 150)),
          child: TextFormField(
            focusNode: _passwordFocus,
            onFieldSubmitted: (value) {
              onSubmit();
            },
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            controller: _passwordController,
            decoration:
                textFieldDecoration('Введите password', _passwordController),
          ),
        );
      }

      return kTryRiverpod
          ? Consumer(builder: (context, ref, child) {
              return _passwordFieldUI(
                () {
                  ref.read(authNotifierProvider.notifier).loginWithUsername(
                        _usernameController.text,
                        _passwordController.text,
                      );
                },
              );
            })
          : _passwordFieldUI(
              () {
                context.read<AuthBloc>().add(
                      LoginWithUsername(
                        _usernameController.text,
                        _passwordController.text,
                      ),
                    );
              },
            );
    }

    Widget _loginButton() {
      return ConstrainedBox(
        constraints: BoxConstraints.loose(const Size(500, 150)),
        child: ElevatedButton(
          style: elevatedButtonStyle(),
          onPressed: () {
            // context.read<AuthBloc>().add(
            //       LoginWithUsername(
            //         _usernameController.text,
            //         _passwordController.text,
            //       ),
            //     );
          },
          child: Text(
            'Войти',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
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
        ),
      ),
    );
  }
}
