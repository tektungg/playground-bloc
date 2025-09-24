import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'features/reimbursement/presentation/bloc/reimbursement_bloc.dart';
import 'features/reimbursement/presentation/screens/reimbursement_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reimbursement App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
      ),
      home: BlocProvider(
        create: (context) => sl<ReimbursementBloc>(),
        child: const ReimbursementListScreen(),
      ),
    );
  }
}
