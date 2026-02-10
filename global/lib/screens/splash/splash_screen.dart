import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_bloc.dart';
import 'package:global/bloc/auth/auth_state.dart';
import 'package:global/screens/login/login_screen.dart';

import 'package:global/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Completer<void> _minSplashCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!_minSplashCompleter.isCompleted) {
        _minSplashCompleter.complete();
      }
    });
  }

  void _navigate(AuthState state) async {
    // Ensure minimum splash time has passed
    await _minSplashCompleter.future;
    if (!mounted) return;

    if (state is AuthAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (state is AuthUnauthenticated) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
    // If AuthFailure, maybe go to login?
    else if (state is AuthFailure) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated ||
            state is AuthUnauthenticated ||
            state is AuthFailure) {
          _navigate(state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              "assets/images/login/Logo GOE (1) 1.png",
              height: 229,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.logo_dev, size: 100),
            ),
          ),
        ),
      ),
    );
  }
}
