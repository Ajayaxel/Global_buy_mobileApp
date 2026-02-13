import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_bloc.dart';
import 'package:global/bloc/auth/auth_event.dart';
import 'package:global/bloc/cart/cart_bloc.dart';
import 'package:global/bloc/cart/cart_state.dart';
import 'package:global/bloc/document/document_bloc.dart';
import 'package:global/bloc/document/document_state.dart';
import 'package:global/bloc/home/home_bloc.dart';
import 'package:global/bloc/home/home_state.dart';
import 'package:global/bloc/order/order_bloc.dart';
import 'package:global/bloc/order/order_state.dart';
import 'package:global/bloc/profile/profile_bloc.dart';
import 'package:global/bloc/profile/profile_state.dart';
import 'package:global/screens/cart/cart_screen.dart';
import 'package:global/screens/chat/messages_screen.dart';
import 'package:global/screens/home/home_screen.dart';
import 'package:global/screens/profile/profile_screen.dart';
import 'package:global/screens/orders/orders_screen.dart';
import 'package:global/screens/login/login_screen.dart';
import 'package:global/widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MessagesScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleUnauthenticated() {
    // Clear token and navigate to login
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError &&
                (state.message.contains('Unauthenticated user') ||
                    state.message.contains('Unauthenticated'))) {
              _handleUnauthenticated();
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError &&
                (state.message.contains('Unauthenticated user') ||
                    state.message.contains('Unauthenticated'))) {
              _handleUnauthenticated();
            }
          },
        ),
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderError &&
                (state.message.contains('Unauthenticated user') ||
                    state.message.contains('Unauthenticated'))) {
              _handleUnauthenticated();
            }
          },
        ),
        BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError &&
                (state.error.contains('Unauthenticated user') ||
                    state.error.contains('Unauthenticated'))) {
              _handleUnauthenticated();
            }
          },
        ),
        BlocListener<DocumentBloc, DocumentState>(
          listener: (context, state) {
            if (state is DocumentFailure &&
                (state.error.contains('Unauthenticated user') ||
                    state.error.contains('Unauthenticated'))) {
              _handleUnauthenticated();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            _screens[_selectedIndex],
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNav(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
