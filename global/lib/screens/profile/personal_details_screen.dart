import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/bloc/profile/profile_bloc.dart';
import 'package:global/bloc/profile/profile_event.dart';
import 'package:global/bloc/profile/profile_state.dart';
import 'package:global/widgets/gbtn.dart';
import 'package:global/widgets/custom_toast.dart';
import 'package:global/widgets/custom_loading_indicator.dart';
import 'package:image_picker/image_picker.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _fullNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _address2Controller = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  void _prefillData() {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      final profile = state.profile;
      _fullNameController.text = profile.fullName;
      _companyNameController.text = profile.companyName ?? "";
      _emailController.text = profile.email;
      _phoneController.text = profile.phone ?? "";
      _addressController.text = profile.address ?? "";
      _address2Controller.text = profile.address2 ?? "";
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _address2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          CustomToast.show(context, state.message);
          Navigator.pop(context);
        } else if (state is ProfileError) {
          CustomToast.show(context, state.message, isError: true);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xFFF6F6F6),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                            ),
                          ),
                        ),
                        const Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Profile Image with Camera Icon
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              String? avatarUrl;
                              if (state is ProfileLoaded) {
                                avatarUrl = state.profile.avatarUrl;
                              }

                              return CircleAvatar(
                                radius: 50,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : (avatarUrl != null
                                              ? NetworkImage(avatarUrl)
                                              : const AssetImage(
                                                  'assets/images/home/cobalt.png',
                                                ))
                                          as ImageProvider,
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            top: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap to change",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    // Form Fields
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _fullNameController,
                              icon: Icons.person_outline,
                              hintText: "Full Name",
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _companyNameController,
                              icon: Icons.business_outlined,
                              hintText: "Company Name",
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _emailController,
                              icon: Icons.email_outlined,
                              hintText: "Email",
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _phoneController,
                              icon: Icons.phone_outlined,
                              hintText: "Phone",
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _addressController,
                              icon: Icons.location_on_outlined,
                              hintText: "Address",
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _address2Controller,
                              icon: Icons.location_on_outlined,
                              hintText: "Address 2",
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Save Button
                    GBtn(
                      text: "Save Changes",
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                          UpdateProfile(
                            fullName: _fullNameController.text,
                            companyName: _companyNameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            address2: _address2Controller.text,
                            avatarPath: _selectedImage?.path,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileUpdating) {
                return const CustomLoadingPage();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black, size: 20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
