import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/ticket/ticket_repository.dart';

class TicketController extends ValueNotifier<StateApp> {
  List<RecipeModel> info = [];

  final stateLikes = ValueNotifier<StateApp>(StateApp.start);
  final stateShared = ValueNotifier<StateApp>(StateApp.start);

  final TicketRepository _profileRepository;

  TicketController(super.value, this._profileRepository);

  Future getInfo() async {
    stateLikes.value = StateApp.loading;
    try {
      info = await _profileRepository.getLikesProfile();
      stateLikes.value = StateApp.success;
    } catch (e) {
      stateLikes.value = StateApp.error;
    }
  }
}
