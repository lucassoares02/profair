import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/negotiation_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class NegotiationController extends ValueNotifier<StateApp> {
  List<NegotiationModel> negotiations = [];

  final stateNegotiations = ValueNotifier<StateApp>(StateApp.start);

  final NegotiationRepository _negotiationsRepository;

  NegotiationController(super.value, this._negotiationsRepository);

  Future findNegotiations(int? codeBranch, int? codeProvider) async {
    stateNegotiations.value = StateApp.loading;
    try {
      negotiations = await _negotiationsRepository.getNegotiations(codeBranch, codeProvider);
      stateNegotiations.value = StateApp.success;
    } catch (e) {
      stateNegotiations.value = StateApp.error;
    }
  }
}
