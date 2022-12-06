import 'package:chat_app/common/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  final bool isRegistering;

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => RegisterPage(
        isRegistering: isRegistering
      )
    );
  }

  const RegisterPage({
    required this.isRegistering,
    super.key
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if(!isValid) {
      return;
    }

    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String username = _userNameController.text;

    try {
      await supabase.auth.signUp(
        email: email, password: password, data: {'username': username
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        ChatPage.route(), (route) => false
      );
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email')
              ),
              validator: (val) {
                if(val == null || val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Password')
              ),
              validator: (val) {
                if(val == null || val.isEmpty) {
                  return 'Required';
                }
                if(val.length < 6) {
                  return '6 characters minimum';
                }
                return null;
              },
            ),
            formSpacer,
            TextFormField(
              controller: _userNameController,
              decoration: const InputDecoration(
                label: Text('Username')
              ),
              validator: (val) {
                if(val == null || val.isEmpty) {
                  return 'Required';
                }
                final bool isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                if(!isValid) {
                  return '3-24 long with alphanumeric of underscore';
                }
                return null;
              },
            ),
            formSpacer,
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: const Text('Register')
            ),
            formSpacer,
            TextButton(
              onPressed: () {
                Navigator.of(context).push(LoginPage.route());
              },
              child: const Text('I already have an account')
            )
          ],
        )
      )
    );
  }
}