import 'package:profair/src/repositories/list_attractions_model.dart';
import 'package:profair/src/repositories/list_attractions_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ListAttractionsController extends ValueNotifier<StateApp> {
  List<ListAttractionsModel> listAttractions = [];

  final stateAttractions = ValueNotifier<StateApp>(StateApp.start);

  final ListAttractionsRepository _listAttractionsRepository;

  ListAttractionsController(super.value, this._listAttractionsRepository);

  Future findAttractions() async {
    stateAttractions.value = StateApp.loading;
    try {
      listAttractions = await _listAttractionsRepository.getRequestsStores();
      stateAttractions.value = StateApp.success;
    } catch (e) {
      print("Error Controller List Attractions: $e");
      stateAttractions.value = StateApp.error;
    }
  }
}
