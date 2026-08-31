/// Dados básicos de um CNPJ retornados pela BrasilAPI (via backend).
class CnpjModel {
  final String cnpj; // dígitos
  final String? razaoSocial;
  final String? nomeFantasia;
  final String? situacaoCadastral;
  final String? municipio;
  final String? uf;
  final String? telefone;
  final String? email;
  final num? capitalSocial;
  final String? codigoNatureza;
  final Map<String, dynamic>? raw;

  CnpjModel({
    required this.cnpj,
    this.razaoSocial,
    this.nomeFantasia,
    this.situacaoCadastral,
    this.municipio,
    this.uf,
    this.telefone,
    this.email,
    this.capitalSocial,
    this.codigoNatureza,
    this.raw,
  });

  factory CnpjModel.fromJson(Map<String, dynamic> json) {
    return CnpjModel(
      cnpj: (json["cnpj"] ?? "").toString(),
      razaoSocial: json["razao_social"],
      nomeFantasia: json["nome_fantasia"],
      situacaoCadastral: json["situacao_cadastral"],
      municipio: json["municipio"],
      uf: json["uf"],
      telefone: json["telefone"],
      email: json["email"],
      capitalSocial: json["capital_social"] is num ? json["capital_social"] : num.tryParse("${json["capital_social"]}"),
      codigoNatureza: json["codigo_natureza"]?.toString(),
      raw: json["raw"] is Map<String, dynamic> ? json["raw"] : null,
    );
  }

  /// Payload enviado ao backend no cadastro.
  Map<String, dynamic> toCadastroJson() {
    return {
      "cnpj": cnpj,
      "razao_social": razaoSocial,
      "nome_fantasia": nomeFantasia,
      "situacao_cadastral": situacaoCadastral,
      "municipio": municipio,
      "uf": uf,
      "telefone": telefone,
      "email": email,
      "capital_social": capitalSocial,
      "codigo_natureza": codigoNatureza,
      "raw": raw,
    };
  }
}
