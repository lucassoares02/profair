import 'package:profair/src/repositories/consultants_model.dart';
import 'package:profair/src/repositories/consultants_repositoy.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ConsultantsController extends ValueNotifier<StateApp> {
  Iterable<ConsultantsModel> consultants = [];
  Iterable<ConsultantsModel> consultantsBackup = [];

  final stateSearchStore = ValueNotifier<StateApp>(StateApp.start);
  final stateConsultants = ValueNotifier<StateApp>(StateApp.start);

  final ConsultantsRepository _consultantsRepository;

  ConsultantsController(super.value, this._consultantsRepository);

  Future findAllByProvider(String provider) async {
    stateConsultants.value = StateApp.loading;
    try {
      consultantsBackup = await _consultantsRepository.findAllByProvider(provider);
      consultants = consultantsBackup;

      stateConsultants.value = StateApp.success;
    } catch (e) {
      stateConsultants.value = StateApp.error;
    }
  }
}
