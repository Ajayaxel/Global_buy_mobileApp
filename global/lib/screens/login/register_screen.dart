import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_bloc.dart';
import 'package:global/bloc/auth/auth_event.dart';
import 'package:global/bloc/auth/auth_state.dart';
import 'package:global/repositories/auth_repository.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:global/widgets/custom_toast.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/screens/login/login_screen.dart';
import 'package:global/screens/login/verify_account_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            CustomToast.show(context, state.message);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyAccountScreen(
                  email: state.user?.email ?? _emailController.text,
                  initialOtp: state.user?.otp,
                ),
              ),
            );
          } else if (state is AuthFailure) {
            CustomToast.show(context, state.error, isError: true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: const Color(0xffF6F6F6),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 100),
                              // Logo Section
                              Center(
                                child: Image.asset(
                                  'assets/images/login/Logo GOE (1) 1.png',
                                  height: 179,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.logo_dev,
                                      size: 100,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Register Form Container
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32),
                                      topRight: Radius.circular(32),
                                    ),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          'Join the Global Ore Exchange',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        // Full Name Field
                                        TextFormField(
                                          controller: _nameController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your full name';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Full Name',
                                            prefixIcon: const Icon(
                                              Icons.person_outline,
                                              color: Colors.grey,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffF6F6F6),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Company Name Field
                                        TextFormField(
                                          controller: _companyController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your company name';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Company Name',
                                            prefixIcon: const Icon(
                                              Icons.business_outlined,
                                              color: Colors.grey,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffF6F6F6),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Email Field
                                        TextFormField(
                                          controller: _emailController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                            ).hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Email',
                                            prefixIcon: const Icon(
                                              Icons.email_outlined,
                                              color: Colors.grey,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffF6F6F6),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Phone Number Field
                                        TextFormField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your phone number';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Phone Number',
                                            prefixIcon: const Icon(
                                              Icons.phone_outlined,
                                              color: Colors.grey,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffF6F6F6),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Password Field
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: !_isPasswordVisible,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a password';
                                            }
                                            if (value.length < 6) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            prefixIcon: const Icon(
                                              Icons.lock_outline,
                                              color: Colors.grey,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffF6F6F6),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        GBtn(
                                          text: 'Sign Up',
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthBloc>().add(
                                                RegisterRequested(
                                                  fullName:
                                                      _nameController.text,
                                                  companyName:
                                                      _companyController.text,
                                                  email: _emailController.text,
                                                  phone: _phoneController.text,
                                                  password:
                                                      _passwordController.text,
                                                  address:
                                                      '', // Passing empty string as address is not in UI but required by API
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Already have an account? ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Sign In',
                                                style: TextStyle(
                                                  color: Color(0xFFBA983F),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state is AuthLoading) const CustomLoadingPage(),
            ],
          );
        },
      ),
    );
  }
}
