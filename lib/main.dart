import 'package:flutter/material.dart';
import 'package:flutter_hit_api/providers/consultation_provider.dart';
import 'package:flutter_hit_api/screens/consultation_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConsultationProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ConsultationListScreen());
  }
}
