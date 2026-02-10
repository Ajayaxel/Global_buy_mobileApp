import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await profileRepository.getProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    emit(ProfileUpdating());
    try {
      final updatedProfile = await profileRepository.updateProfile(
        fullName: event.fullName,
        companyName: event.companyName,
        email: event.email,
        phone: event.phone,
        address: event.address,
        address2: event.address2,
        avatarPath: event.avatarPath,
      );
      emit(
        ProfileUpdateSuccess(updatedProfile, "Profile updated successfully."),
      );
      // Also emit ProfileLoaded so the UI updates globally
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      if (currentState is ProfileLoaded) {
        emit(ProfileLoaded(currentState.profile));
      }
      emit(ProfileError(e.toString()));
    }
  }
}
