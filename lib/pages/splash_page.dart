import 'package:chat_app/common/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _redirect() async {
    // await for the widget to mount
    await Future.delayed(Duration.zero);

    final Session? session = supabase.auth.currentSession;

    if(session == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
        .pushAndRemoveUntil(RegisterPage.route(), (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushAndRemoveUntil(ChatPage.route(), (route) => false);
    }
  }
  
  @override
  void initState() {
    _redirect();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: preloader);
  }
}