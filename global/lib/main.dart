import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_bloc.dart';
import 'package:global/bloc/auth/auth_event.dart';
import 'package:global/bloc/document/document_bloc.dart';
import 'package:global/bloc/profile/profile_bloc.dart';
import 'package:global/repositories/auth_repository.dart';
import 'package:global/repositories/profile_repository.dart';
import 'package:global/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: authRepository)
                ..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => DocumentBloc(authRepository: authRepository),
        ),
        BlocProvider(
          create: (context) =>
              ProfileBloc(profileRepository: ProfileRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Global Ore Exchange',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF6F6F6),
          fontFamily: 'Satoshi',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
