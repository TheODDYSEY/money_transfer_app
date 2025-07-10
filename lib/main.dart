import 'package:flutter/material.dart';
import 'pages/login_page_simple.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MoneyTransferApp());
}

class MoneyTransferApp extends StatelessWidget {
  const MoneyTransferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftPay - Money Transfer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
