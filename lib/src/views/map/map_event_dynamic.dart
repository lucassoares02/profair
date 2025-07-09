import 'dart:math' as math;
import 'package:flutter/material.dart';

class MapEventDynamic extends StatefulWidget {
  const MapEventDynamic({super.key, required this.map});
  final String map;
  @override
  State<MapEventDynamic> createState() => _MapEventDynamicState();
}

class _MapEventDynamicState extends State<MapEventDynamic> {
  List<Map<String, dynamic>> _stands = [];

  @override
  void initState() {
    super.initState();
    _carregarStands();
  }

  Future<void> _carregarStands() async {
    setState(() => _stands = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa do Evento")),
      body: InteractiveViewer(
        minScale: 0.01,
        maxScale: 9,
        child: Stack(
          children: [
            // === background rotacionado, ocupando só 90% do container ===
            Positioned.fill(
              child: Center(
                child: FractionallySizedBox(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Image.network(
                      widget.map,
                      fit: BoxFit.cover, // preenche o boxFraction mantendo proporção
                    ),
                  ),
                ),
              ),
            ),

            // === marcadores de stands ===
            ..._stands.map((stand) {
              return Positioned(
                left: stand['left'].toDouble(),
                top: stand['top'].toDouble(),
                width: stand['width'].toDouble(),
                height: stand['height'].toDouble(),
                child: GestureDetector(
                  onTap: () => _mostrarDetalhesDoStand(
                    context,
                    stand['nome'],
                    'Fornecedor: ${stand['fornecedor']}',
                  ),
                  child: Container(color: stand['color']),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhesDoStand(BuildContext context, String titulo, String descricao) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(descricao),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
    );
  }
}
