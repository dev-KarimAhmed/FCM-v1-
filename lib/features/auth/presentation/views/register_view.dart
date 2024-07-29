// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/presentation/manger/auth_cubit/auth_cubit.dart';
import 'package:test/features/home/presentation/views/home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeView()));
        }
        if (state is AuthError) {
          log(state.message);
        }
      },
      builder: (context, state) {
        AuthCubit cubit = context.read<AuthCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: state is AuthLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        // TextFormField(
                        //   controller: _confirmPasswordController,
                        //   decoration:
                        //       const InputDecoration(labelText: 'Confirm Password'),
                        //   obscureText: true,
                        //   validator: (value) {
                        //     if (value != _passwordController.text) {
                        //       return 'Passwords do not match';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              cubit.register(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                              );
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Don\'t have an account? Sign up'),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
