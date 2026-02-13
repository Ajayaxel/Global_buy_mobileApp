import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/profile/profile_bloc.dart';
import 'package:global/bloc/profile/profile_event.dart';
import 'package:global/bloc/profile/profile_state.dart';
import 'package:global/bloc/document/document_bloc.dart';
import 'package:global/bloc/document/document_event.dart';
import 'package:global/bloc/document/document_state.dart';
import 'package:global/screens/profile/documents_screen.dart';
import 'package:global/screens/profile/payment_methods_screen.dart';
import 'package:global/screens/profile/personal_details_screen.dart';
import 'package:global/screens/profile/setting_screen.dart';
import 'package:global/screens/profile/support_screen.dart';
import 'package:global/screens/login/login_screen.dart';
import 'package:global/widgets/shimmer_widget.dart';
import 'package:global/widgets/network_error_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if not already loaded to avoid redundant API calls
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is! ProfileLoaded) {
      context.read<ProfileBloc>().add(FetchProfile());
    }

    final documentState = context.read<DocumentBloc>().state;
    if (documentState is! DocumentFetchSuccess) {
      context.read<DocumentBloc>().add(FetchDocumentsRequested());
    }
  }

  Future<void> _onRefresh() async {
    context.read<ProfileBloc>().add(FetchProfile());
    context.read<DocumentBloc>().add(FetchDocumentsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Dynamic User Information Section
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return Column(
                          children: [
                            const ShimmerWidget.circular(
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 10),
                            const ShimmerWidget.rectangular(
                              width: 150,
                              height: 24,
                            ),
                            const SizedBox(height: 5),
                            const ShimmerWidget.rectangular(
                              width: 120,
                              height: 16,
                            ),
                            const SizedBox(height: 5),
                            const ShimmerWidget.rectangular(
                              width: 180,
                              height: 16,
                            ),
                          ],
                        );
                      } else if (state is ProfileError) {
                        return NetworkErrorWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<ProfileBloc>().add(FetchProfile());
                          },
                        );
                      } else if (state is ProfileLoaded) {
                        final profile = state.profile;
                        return Column(
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: profile.avatarUrl != null
                                  ? NetworkImage(profile.avatarUrl!)
                                  : const AssetImage(
                                          'assets/images/home/cobalt.png',
                                        )
                                        as ImageProvider,
                            ),
                            const SizedBox(height: 10),
                            // Name
                            Text(
                              profile.fullName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            // Company
                            if (profile.companyName != null)
                              Text(
                                profile.companyName!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(height: 2),
                            // Email
                            Text(
                              profile.email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox(height: 100);
                    },
                  ),

                  const SizedBox(height: 15),
                  // Stat Cards
                  _rowWidget(),
                  const SizedBox(height: 10),
                  // Menu List
                  _buildMenuSection(context),
                  const SizedBox(height: 10),
                  // Sign Out
                  _buildSignOutSection(context),
                  const SizedBox(height: 10),
                  // Footer
                  const Text(
                    "Global Ore Exchange v1.0.0",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 70), // Space for bottom nav
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowWidget() {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        String docCount = "00";

        if (state is DocumentFetchSuccess) {
          int count = 0;
          if (state.documents.governmentId != null) count++;
          if (state.documents.businessLicence != null) count++;
          if (state.documents.proofOfAddress != null) count++;
          docCount = count.toString().padLeft(2, '0');
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/home/notififctioncube.png',
                count: "02",
                label: "Orders",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.description_outlined,
                count: docCount,
                label: "Documents",
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            "Personal",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalDetailsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            "Documents",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            "Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            "Payment Mode",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem("Terms and conditions"),
          _buildDivider(),
          _buildMenuItem(
            "Support",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildMenuItem(
        "Sign Out",
        isDestructive: true,
        onTap: () {
          _showSignOutSheet(context);
        },
      ),
    );
  }

  void _showSignOutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Sign Out",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Are you sure you want to sign out?",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close sheet
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    IconData? icon,
    String? imagePath,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (imagePath != null)
            Image.asset(imagePath, width: 40, height: 40, color: Colors.black)
          else if (icon != null)
            Icon(icon, size: 40, color: Colors.black),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDestructive ? Colors.red : Colors.black,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFEEEEEE),
    );
  }
}
