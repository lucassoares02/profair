import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/profile/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileController extends ValueNotifier<StateApp> {
  List<RecipeModel> likes = [];
  List<RecipeModel> shared = [];
  final stateLikes = ValueNotifier<StateApp>(StateApp.start);
  final stateShared = ValueNotifier<StateApp>(StateApp.start);
  final ProfileRepository _profileRepository;

  ProfileController(super.value, this._profileRepository);

  Future getLikes() async {
    stateLikes.value = StateApp.loading;
    try {
      likes = await _profileRepository.getLikesProfile();
      stateLikes.value = StateApp.success;
    } catch (e) {
      stateLikes.value = StateApp.error;
    }
  }

  Future getShared() async {
    stateShared.value = StateApp.loading;
    try {
      shared = await _profileRepository.getSharedProfile();
      stateShared.value = StateApp.success;
    } catch (e) {
      stateShared.value = StateApp.error;
    }
  }
}
