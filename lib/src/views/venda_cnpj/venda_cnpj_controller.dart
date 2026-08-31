import 'package:flutter/material.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/venda_cnpj/venda_cnpj_model.dart';
import 'package:profair/src/views/venda_cnpj/venda_cnpj_repository.dart';

class VendaCnpjController {
  VendaCnpjController(this._repository);

  final VendaCnpjRepository _repository;
  int _consultRequest = 0;

  // Estado da consulta ao CNPJ.
  final stateConsult = ValueNotifier<StateApp>(StateApp.start);
  // Estado do cadastro (salvar).
  final stateSave = ValueNotifier<StateApp>(StateApp.start);

  // CNPJ atualmente consultado, aguardando confirmação.
  final consulted = ValueNotifier<CnpjModel?>(null);
  // Lojas (CNPJs) já cadastradas nesta sessão.
  final ValueNotifier<List<CnpjModel>> added =
      ValueNotifier<List<CnpjModel>>([]);

  String? errorMessage;

  // Comprador (consultor) e acesso criados na primeira gravação — reaproveitados.
  int? consultorId;
  dynamic codAcesso;

  Future<bool> consultar(String cnpjDigits) async {
    final request = ++_consultRequest;
    errorMessage = null;
    consulted.value = null;
    stateConsult.value = StateApp.loading;
    try {
      final data = await _repository.consultar(cnpjDigits);
      if (request != _consultRequest) return false;

      consulted.value = data;
      stateConsult.value = StateApp.success;
      return true;
    } catch (e) {
      if (request != _consultRequest) return false;

      errorMessage = "Não foi possível consultar o CNPJ.";
      stateConsult.value = StateApp.error;
      return false;
    }
  }

  void limparConsulta() {
    _consultRequest++;
    errorMessage = null;
    consulted.value = null;
    stateConsult.value = StateApp.start;
  }

  /// Salva o CNPJ consultado, criando/atualizando o comprador na primeira vez.
  /// Retorna true em sucesso.
  Future<bool> salvarCnpjConsultado({
    required String? codAcessoFornecedor,
    required String nome,
    required String telefone,
    required String email,
  }) async {
    final cnpj = consulted.value;
    if (cnpj == null) return false;

    stateSave.value = StateApp.loading;
    try {
      final response = await _repository.cadastrar(
        codAcessoFornecedor: codAcessoFornecedor,
        comprador: {"nome": nome, "telefone": telefone, "email": email},
        cnpjs: [cnpj],
        consultorId: consultorId,
        codAcesso: codAcesso,
      );

      consultorId = response["consultorId"] is int
          ? response["consultorId"]
          : int.tryParse("${response["consultorId"]}");
      codAcesso = response["codAcesso"];

      added.value = [...added.value, cnpj];
      consulted.value = null;
      stateSave.value = StateApp.success;
      return true;
    } catch (e) {
      errorMessage = "Não foi possível salvar o CNPJ.";
      stateSave.value = StateApp.error;
      return false;
    }
  }

  void dispose() {
    stateConsult.dispose();
    stateSave.dispose();
    consulted.dispose();
    added.dispose();
  }
}
