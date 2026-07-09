import 'package:flutter/material.dart';

/// Representa um stand desenhado sobre o mapa do evento.
/// As coordenadas são normalizadas (0..1) relativas à imagem natural do mapa.
class StandModel {
  final int? codStand;
  final int? codOrg;
  final int? codForn;
  final String? nome;
  final double x;
  final double y;
  final double w;
  final double h;
  final String? cor;
  final int rotacao;

  // Dados do fornecedor vinculado (quando houver)
  final String? nomeForn;
  final String? fornImage;
  final String? fornColor;

  StandModel({
    this.codStand,
    this.codOrg,
    this.codForn,
    this.nome,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.cor,
    this.rotacao = 0,
    this.nomeForn,
    this.fornImage,
    this.fornColor,
  });

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static int? _toIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  factory StandModel.fromJson(Map<String, dynamic> json) {
    return StandModel(
      codStand: _toIntOrNull(json["codStand"]),
      codOrg: _toIntOrNull(json["codOrg"]),
      codForn: _toIntOrNull(json["codForn"]),
      nome: json["nome"]?.toString(),
      x: _toDouble(json["x"]),
      y: _toDouble(json["y"]),
      w: _toDouble(json["w"]),
      h: _toDouble(json["h"]),
      cor: json["cor"]?.toString(),
      rotacao: _toIntOrNull(json["rotacao"]) ?? 0,
      nomeForn: json["nomeForn"]?.toString(),
      fornImage: json["fornImage"]?.toString(),
      fornColor: json["fornColor"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "codStand": codStand,
        "codOrg": codOrg,
        "codForn": codForn,
        "nome": nome,
        "x": x,
        "y": y,
        "w": w,
        "h": h,
        "cor": cor,
        "rotacao": rotacao,
      };

  /// Cor de preenchimento do retângulo. Aceita `#AARRGGBB`, `#RRGGBB`,
  /// `RRGGBB` ou um inteiro em string. Usa um roxo translúcido como fallback.
  Color get fillColor => parseColor(cor, const Color(0x806E41FF));

  static Color parseColor(String? hex, Color fallback) {
    if (hex == null || hex.trim().isEmpty) return fallback;
    try {
      final asInt = int.tryParse(hex);
      if (asInt != null && !hex.contains('#')) return Color(asInt);
      final clean = hex.replaceAll(RegExp(r'^(0x|0X|#)'), '');
      if (clean.length == 6) return Color(int.parse('FF$clean', radix: 16));
      if (clean.length == 8) return Color(int.parse(clean, radix: 16));
    } catch (_) {}
    return fallback;
  }
}
