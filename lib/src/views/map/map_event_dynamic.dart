import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapEventDynamic extends StatefulWidget {
  const MapEventDynamic({super.key});

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
    final jsonString = [
      {"id": "A1", "nome": "Stand A1", "fornecedor": "Acme Corp", "left": 100, "top": 150, "width": 30, "height": 30, "color": const Color(0xffff0000)},
      {"id": "B3", "nome": "Stand B3", "fornecedor": "GlobalTech", "left": 200, "top": 300, "width": 30, "height": 30, "color": const Color(0xff00ffff)}
    ];
    final data = jsonString as List;
    setState(() {
      _stands = data.cast<Map<String, dynamic>>();
    });
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
            // A imagem do mapa agora ocupa toda a tela
            Positioned.fill(
              child: Image.network(
                'https://www.centrodeconvencoes.ms.gov.br/wp-content/uploads/2015/05/Geral2.jpg',
                fit: BoxFit.cover, // Garantir que a imagem preencha a tela
              ),
            ),
            // Marcadores de stands
            ..._stands.map((stand) => Positioned(
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
                    child: Container(
                      decoration: BoxDecoration(color: stand["color"] // Forma circular
                          ),
                    ),
                  ),
                )),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }
}
