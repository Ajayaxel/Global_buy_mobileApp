import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_bloc.dart';
import 'package:global/bloc/auth/auth_event.dart';
import 'package:global/bloc/document/document_bloc.dart';
import 'package:global/bloc/profile/profile_bloc.dart';
import 'package:global/bloc/profile/profile_event.dart';
import 'package:global/repositories/auth_repository.dart';
import 'package:global/repositories/profile_repository.dart';
import 'package:global/screens/splash/splash_screen.dart';

import 'package:global/bloc/home/home_bloc.dart';
import 'package:global/bloc/home/home_event.dart';
import 'package:global/repositories/home_repository.dart';
import 'package:global/bloc/cart/cart_bloc.dart';
import 'package:global/repositories/cart_repository.dart';
import 'package:global/bloc/order/order_bloc.dart';
import 'package:global/bloc/order/order_detail_bloc.dart';
import 'package:global/repositories/order_repository.dart';
import 'package:global/bloc/negotiation/negotiation_bloc.dart';
import 'package:global/repositories/negotiation_repository.dart';
import 'package:global/bloc/chat/chat_bloc.dart';
import 'package:global/repositories/chat_repository.dart';

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
              ProfileBloc(profileRepository: ProfileRepository())
                ..add(FetchProfile()),
        ),
        BlocProvider(
          create: (context) =>
              HomeBloc(homeRepository: HomeRepository())..add(FetchHomeData()),
        ),
        BlocProvider(
          create: (context) => CartBloc(cartRepository: CartRepository()),
        ),
        BlocProvider(
          create: (context) => OrderBloc(orderRepository: OrderRepository()),
        ),
        BlocProvider(
          create: (context) =>
              OrderDetailBloc(orderRepository: OrderRepository()),
        ),
        BlocProvider(
          create: (context) =>
              NegotiationBloc(negotiationRepository: NegotiationRepository()),
        ),
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: ChatRepository()),
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
