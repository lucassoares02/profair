import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/negotiation_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class NegotiationController extends ValueNotifier<StateApp> {
  List<NegotiationModel> negotiations = [];

  final stateNegotiations = ValueNotifier<StateApp>(StateApp.start);
  final stateOrderObservation = ValueNotifier<StateApp>(StateApp.start);
  String orderObservation = "";

  final NegotiationRepository _negotiationsRepository;

  NegotiationController(super.value, this._negotiationsRepository);

  Future findNegotiations(int? codeBranch, int? codeProvider) async {
    stateNegotiations.value = StateApp.loading;
    try {
      negotiations = await _negotiationsRepository.getNegotiations(
          codeBranch, codeProvider);
      stateNegotiations.value = StateApp.success;
    } catch (e) {
      stateNegotiations.value = StateApp.error;
    }
  }

  Future findNegotiationsGroup(int? codeGroup, int? codeProvider) async {
    stateNegotiations.value = StateApp.loading;
    try {
      negotiations = await _negotiationsRepository.findNegotiationsGroup(
          codeGroup, codeProvider);
      stateNegotiations.value = StateApp.success;
    } catch (e) {
      stateNegotiations.value = StateApp.error;
    }
  }

  Future findOrderObservation({
    required int? codeProvider,
    required int? codeConsultSeller,
    required int? codeConsultBuyer,
  }) async {
    final codeBranches = negotiations
        .map((negotiation) => negotiation.codAssoc)
        .whereType<int>()
        .toSet()
        .toList();

    if (codeProvider == null || codeBranches.isEmpty) {
      orderObservation = "";
      stateOrderObservation.value = StateApp.success;
      return;
    }

    stateOrderObservation.value = StateApp.loading;
    try {
      orderObservation = "";
      for (final codeBranch in codeBranches) {
        final observation = (await _negotiationsRepository.getOrderObservation(
          codeBranch: codeBranch,
          codeProvider: codeProvider,
          codeConsultSeller: codeConsultSeller,
          codeConsultBuyer: codeConsultBuyer,
        ))
            .trim();

        if (observation.isNotEmpty) {
          orderObservation = observation;
          break;
        }
      }

      stateOrderObservation.value = StateApp.success;
    } catch (e) {
      orderObservation = "";
      stateOrderObservation.value = StateApp.error;
    }
  }
}
