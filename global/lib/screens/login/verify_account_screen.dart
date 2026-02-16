import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/auth/auth_bloc.dart';
import 'package:global/bloc/auth/auth_event.dart';
import 'package:global/bloc/auth/auth_state.dart';
import 'package:global/repositories/auth_repository.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:global/widgets/custom_toast.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/screens/login/upload_document_screen.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String email;
  final String? initialOtp;

  const VerifyAccountScreen({super.key, required this.email, this.initialOtp});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    if (widget.initialOtp != null && widget.initialOtp!.length == 6) {
      _autoFillOtp(widget.initialOtp!);
      // Auto-verify as requested - REMOVED
      /* 
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _verifyOtp(context);
      });
      */
    }
  }

  void _autoFillOtp(String otp) {
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = otp[i];
    }
    // Set focus to last field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[5].requestFocus();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is OtpVerificationLoading ||
        authState is OtpVerificationSuccess) {
      return;
    }

    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      CustomToast.show(
        context,
        'Please enter a valid 6-digit OTP',
        isError: true,
      );
      return;
    }
    context.read<AuthBloc>().add(
      VerifyOtpRequested(email: widget.email, otp: otp),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
            if (_controllers.every((c) => c.text.isNotEmpty)) {
              // Optionally auto-submit
              // _verifyOtp(context);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            CustomToast.show(context, state.message);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadDocumentScreen(),
              ),
              (route) => false,
            );
          } else if (state is ResendOtpSuccess) {
            CustomToast.show(context, state.message);
            // Optionally restart timer
            setState(() {
              _secondsRemaining = 30;
            });
            _startTimer();
          } else if (state is AuthFailure) {
            CustomToast.show(context, state.error, isError: true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: const Color(0xffF6F6F6),
                body: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  // Icon
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFBA983F),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Title
                                  const Text(
                                    'Verify Account',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Subtitle
                                  Text(
                                    'We sent a 6 digit code to ${widget.email}.\nEnter it below.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // OTP Fields
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      6,
                                      (index) => _buildOTPField(index),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Resend Text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't receive code? ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _secondsRemaining > 0
                                            ? null
                                            : () {
                                                context.read<AuthBloc>().add(
                                                  ResendOtpRequested(
                                                    email: widget.email,
                                                  ),
                                                );
                                              },
                                        child: Text(
                                          _secondsRemaining > 0
                                              ? "Resend in ${_formatTime(_secondsRemaining)}"
                                              : "Click to Resend",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Continue Button
                                  GBtn(
                                    text: 'Verify OTP',
                                    onPressed: () => _verifyOtp(context),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state is OtpVerificationLoading || state is ResendOtpLoading)
                const CustomLoadingPage(),
            ],
          );
        },
      ),
    );
  }
}
