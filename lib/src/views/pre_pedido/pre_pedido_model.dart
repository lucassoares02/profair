/// Item de um pré-pedido (quantidade sugerida por mercadoria/negociação).
class PrePedidoItem {
  final int codNegociacao;
  final int codMercadoria;
  final int quantidade;

  PrePedidoItem({
    required this.codNegociacao,
    required this.codMercadoria,
    required this.quantidade,
  });

  factory PrePedidoItem.fromJson(Map<String, dynamic> json) {
    return PrePedidoItem(
      codNegociacao: json["codNegociacao"] is int ? json["codNegociacao"] : int.tryParse("${json["codNegociacao"]}") ?? 0,
      codMercadoria: json["codMercadoria"] is int ? json["codMercadoria"] : int.tryParse("${json["codMercadoria"]}") ?? 0,
      quantidade: json["quantidade"] is int ? json["quantidade"] : int.tryParse("${json["quantidade"]}") ?? 0,
    );
  }
}

/// Pré-pedido criado pela organização para um fornecedor.
class PrePedidoModel {
  final int id;
  final String nome;
  final List<PrePedidoItem> itens;

  PrePedidoModel({required this.id, required this.nome, required this.itens});

  factory PrePedidoModel.fromJson(Map<String, dynamic> json) {
    final List itensJson = (json["itens"] as List?) ?? [];
    return PrePedidoModel(
      id: json["id"] is int ? json["id"] : int.tryParse("${json["id"]}") ?? 0,
      nome: (json["nome"] ?? "").toString(),
      itens: itensJson.map((e) => PrePedidoItem.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }
}
