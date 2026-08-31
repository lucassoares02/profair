import 'package:profair/src/shared/http_service.dart';
import 'package:profair/src/views/pre_pedido/pre_pedido_model.dart';

class PrePedidoRepository {
  final httpService = HttpService();

  /// Lista os pré-pedidos ativos de um fornecedor (com os itens).
  Future<List<PrePedidoModel>> byProvider(int codForn) async {
    final response = await httpService.get("pre-pedido/provider/$codForn");
    final List list = response.data as List;
    return list.map((e) => PrePedidoModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
