import 'package:flutter/material.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/tradings_provider/tradings_list_settings.dart';

/// Tela de configurações locais da lista de negociações.
/// Cada opção é persistida em SharedPreferences imediatamente ao alternar.
class TradingsSettingsScreen extends StatefulWidget {
  const TradingsSettingsScreen({super.key});

  @override
  State<TradingsSettingsScreen> createState() => _TradingsSettingsScreenState();
}

class _TradingsSettingsScreenState extends State<TradingsSettingsScreen> {
  TradingsListSettings _settings = TradingsListSettings();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await TradingsListSettings.load();
    if (!mounted) return;
    setState(() {
      _settings = s;
      _loading = false;
    });
  }

  Future<void> _persist() async => _settings.save();

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: colorSecondary))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    "Personalize a exibição da lista de negociações. As preferências ficam salvas apenas neste dispositivo.",
                    style: TextStyle(fontSize: 13, color: onSurface.withValues(alpha: 0.6)),
                  ),
                ),
                _tile(
                  icon: Icons.smart_button_rounded,
                  title: "Botão flutuante de resumo",
                  subtitle: "Exibe um atalho central para o \"Resumo do pedido\" nas abas de negociação.",
                  value: _settings.showFloatingButton,
                  onChanged: (v) => setState(() {
                    _settings.showFloatingButton = v;
                    _persist();
                  }),
                ),
                _tile(
                  icon: Icons.visibility_off_outlined,
                  title: "Ocultar cabeçalho da negociação",
                  subtitle: "Esconde por completo o cabeçalho (compacto ou completo). A data da negociação passa a aparecer no título da aba.",
                  value: _settings.hideHeader,
                  onChanged: (v) => setState(() {
                    _settings.hideHeader = v;
                    _persist();
                  }),
                ),
                // O cabeçalho compacto só faz sentido quando o cabeçalho não está oculto.
                if (!_settings.hideHeader)
                  _tile(
                    icon: Icons.short_text_rounded,
                    title: "Cabeçalho compacto",
                    subtitle: "Mostra apenas o código e a data da negociação, em vez do cartão completo.",
                    value: _settings.compactHeader,
                    onChanged: (v) => setState(() {
                      _settings.compactHeader = v;
                      _persist();
                    }),
                  ),
                _tile(
                  icon: Icons.sell_outlined,
                  title: "Filtro por tags",
                  subtitle: "Exibe as tags dos produtos como filtros no topo de cada negociação.",
                  value: _settings.tagFilters,
                  onChanged: (v) => setState(() {
                    _settings.tagFilters = v;
                    _persist();
                  }),
                ),
                _tile(
                  icon: Icons.exposure_rounded,
                  title: "Seletor de quantidade",
                  subtitle: "Exibe os botões de menos e mais, mantendo o valor central editável pelo teclado.",
                  value: _settings.quantitySelector,
                  onChanged: (v) => setState(() {
                    _settings.quantitySelector = v;
                    _persist();
                  }),
                ),
                _tile(
                  icon: Icons.notes_rounded,
                  title: "Marca e preços em texto",
                  subtitle: "Mostra marca, preço unitário e preço da embalagem em texto sutil separado por ponto, em vez de tags coloridas.",
                  value: _settings.simpleProductInfo,
                  onChanged: (v) => setState(() {
                    _settings.simpleProductInfo = v;
                    _persist();
                  }),
                ),
              ],
            ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: onSurface.withValues(alpha: 0.08)),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        activeColor: colorSecondary,
        value: value,
        onChanged: onChanged,
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorSecondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colorSecondary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(subtitle, style: TextStyle(fontSize: 12.5, color: onSurface.withValues(alpha: 0.55), height: 1.35)),
        ),
      ),
    );
  }
}
