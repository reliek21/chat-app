import 'package:flutter/material.dart';
import 'package:chat_app/common/constants.dart';
import 'package:chat_app/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://qlznqdqeoqnvpadscimx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsem5xZHFlb3FudnBhZHNjaW14Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzAzMDE5ODgsImV4cCI6MTk4NTg3Nzk4OH0.QZti4ppcQO1qiAUKOkEO3lYr9Yzk9_mL8eYMGgnFFnc'
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: appTheme,
      home: const SplashPage()
    );
  }
}