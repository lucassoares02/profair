import 'dart:convert';

import 'package:profair/src/shared/http_service.dart';
import 'package:profair/src/views/venda_cnpj/venda_cnpj_model.dart';

class VendaCnpjRepository {
  final httpService = HttpService();

  /// Consulta os dados básicos de um CNPJ na BrasilAPI (via backend).
  Future<CnpjModel> consultar(String cnpjDigits) async {
    final response = await httpService.get("venda-cnpj/consultar/$cnpjDigits");
    return CnpjModel.fromJson(Map<String, dynamic>.from(response.data));
  }

  /// Cadastra um (ou mais) CNPJ(s) para o comprador informado.
  /// Na primeira chamada, cria o consultor+acesso; nas seguintes, envie
  /// [consultorId]/[codAcesso] para reaproveitar o mesmo comprador.
  /// Retorna a resposta completa (`consultorId`, `codAcesso`, `associados`).
  Future<Map<String, dynamic>> cadastrar({
    required String? codAcessoFornecedor,
    required Map<String, dynamic> comprador,
    required List<CnpjModel> cnpjs,
    int? consultorId,
    dynamic codAcesso,
  }) async {
    // Enviado como form-urlencoded; objetos/arrays vão como string JSON e o
    // backend faz o parse (aceita ambos os formatos).
    final body = {
      "codAcessoFornecedor": codAcessoFornecedor,
      "comprador": jsonEncode(comprador),
      "cnpjs": jsonEncode(cnpjs.map((c) => c.toCadastroJson()).toList()),
      if (consultorId != null) "consultorId": consultorId,
      if (codAcesso != null) "codAcesso": codAcesso,
    };

    final response = await httpService.post("venda-cnpj/cadastrar", body);
    return Map<String, dynamic>.from(response.data);
  }
}
