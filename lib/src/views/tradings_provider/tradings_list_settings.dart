import 'package:shared_preferences/shared_preferences.dart';

/// Preferências locais (SharedPreferences) da lista de negociações do pedido.
/// Nada é salvo no banco — apenas no dispositivo.
class TradingsListSettings {
  static const _kFloatingButton = 'tp_floating_resumo';
  static const _kCompactHeader = 'tp_compact_header';
  static const _kTagFilters = 'tp_tag_filters';
  static const _kSimpleProductInfo = 'tp_simple_product_info';
  static const _kHideHeader = 'tp_hide_header';
  static const _kQuantitySelector = 'tp_quantity_selector';

  bool showFloatingButton;
  bool compactHeader;
  bool tagFilters;
  bool quantitySelector;

  /// true  = marca / preços em texto sutil separados por ponto
  /// false = valores dentro de tags coloridas (formato antigo)
  bool simpleProductInfo;

  /// true = oculta completamente o cabeçalho da negociação (compacto e completo);
  /// nesse caso a data da negociação passa a aparecer no título da aba.
  bool hideHeader;

  TradingsListSettings({
    this.showFloatingButton = true,
    this.compactHeader = false,
    this.tagFilters = false,
    this.quantitySelector = false,
    this.simpleProductInfo = false,
    this.hideHeader = false,
  });

  static Future<TradingsListSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return TradingsListSettings(
      showFloatingButton: prefs.getBool(_kFloatingButton) ?? true,
      compactHeader: prefs.getBool(_kCompactHeader) ?? false,
      tagFilters: prefs.getBool(_kTagFilters) ?? false,
      quantitySelector: prefs.getBool(_kQuantitySelector) ?? false,
      simpleProductInfo: prefs.getBool(_kSimpleProductInfo) ?? false,
      hideHeader: prefs.getBool(_kHideHeader) ?? false,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kFloatingButton, showFloatingButton);
    await prefs.setBool(_kCompactHeader, compactHeader);
    await prefs.setBool(_kTagFilters, tagFilters);
    await prefs.setBool(_kQuantitySelector, quantitySelector);
    await prefs.setBool(_kSimpleProductInfo, simpleProductInfo);
    await prefs.setBool(_kHideHeader, hideHeader);
  }
}
