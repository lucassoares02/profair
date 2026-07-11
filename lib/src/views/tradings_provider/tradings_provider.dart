import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/controllers/finish_trading_controller.dart';
import 'package:profair/src/controllers/tradings_provider_controller.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/repositories/finish_trading_repository.dart';
import 'package:profair/src/repositories/tradings_provider_repository.dart';
import 'package:profair/src/components/header_actions.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/tradings_provider/components/list.dart';
import 'package:profair/src/views/tradings_provider/tradings_list_settings.dart';
import 'package:profair/src/views/tradings_provider/tradings_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ObservationTextFormatter extends TextInputFormatter {
  const _ObservationTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final lowerText = text.toLowerCase();
    final runes = lowerText.runes.toList();
    final firstLetterIndex = runes.indexWhere((rune) {
      final character = String.fromCharCode(rune);
      return character.toLowerCase() != character.toUpperCase();
    });

    if (firstLetterIndex == -1) {
      return newValue.copyWith(text: lowerText, composing: TextRange.empty);
    }

    runes[firstLetterIndex] =
        String.fromCharCode(runes[firstLetterIndex]).toUpperCase().runes.first;

    return newValue.copyWith(
      text: String.fromCharCodes(runes),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

class TradingsProvider extends StatefulWidget {
  const TradingsProvider({
    super.key,
    required this.codeProvider,
    required this.codeBranch,
    this.codeConsult,
    required this.nameBranch,
    required this.codeClient,
    this.listBranchs,
    this.balance,
    this.client,
  });

  final int? codeProvider;
  final int? codeBranch;
  final String? nameBranch;
  final int? codeClient;
  final int? codeConsult;
  final List<ClientsSelectStoreModel>? listBranchs;
  final bool? balance;
  final LoginModel? client;

  @override
  State<TradingsProvider> createState() => _TradingsProviderState();
}

class _TradingsProviderState extends State<TradingsProvider>
    with SingleTickerProviderStateMixin {
  final TradingsProviderController tradingsProviderController =
      TradingsProviderController(StateApp.start, TradingsProviderRepository());
  final FinishTradingController finishTradingController =
      FinishTradingController(StateApp.start, FinishTradingRepository());
  final TextEditingController orderObservation = TextEditingController();
  final FocusNode orderObservationFocus = FocusNode();
  bool _showObservationEditor = false;
  bool _loadingOrderObservation = false;
  String _savedOrderObservation = "";
  int? history;

  TradingsListSettings _settings = TradingsListSettings();

  @override
  void initState() {
    super.initState();
    getFindTradingsProvider();
    loadHistory();
    _loadSettings();
    _loadOrderObservation();
  }

  loadHistory() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    history = sharedPreferences.getInt("history");
  }

  Future<void> _loadSettings() async {
    final s = await TradingsListSettings.load();
    if (!mounted) return;
    setState(() => _settings = s);
  }

  String? _formatTerm(String? term) {
    if (term == null || term.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(term));
    } catch (_) {
      return null;
    }
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TradingsSettingsScreen()),
    );
    // Recarrega as preferências ao voltar para refletir mudanças na hora.
    _loadSettings();
  }

  int _observationAssociatedCode() {
    for (final branch in widget.listBranchs ?? <ClientsSelectStoreModel>[]) {
      if (branch.checked == true && branch.relationshipCode != null) {
        return branch.relationshipCode!;
      }
    }

    if (widget.listBranchs?.isNotEmpty == true &&
        widget.listBranchs!.first.relationshipCode != null) {
      return widget.listBranchs!.first.relationshipCode!;
    }

    return widget.codeBranch!;
  }

  Future<void> _loadOrderObservation() async {
    if (widget.codeProvider == null ||
        widget.codeClient == null ||
        widget.codeConsult == null) {
      return;
    }

    setState(() => _loadingOrderObservation = true);
    final observation = await tradingsProviderController
        .tradingsProviderRepository
        .getOrderObservation(
      codeBranch: _observationAssociatedCode(),
      codeProvider: widget.codeProvider!,
      codeConsultSeller: widget.codeConsult!,
      codeConsultBuyer: widget.codeClient!,
    );

    if (!mounted) return;
    setState(() {
      _savedOrderObservation = observation.trim();
      orderObservation.text = _savedOrderObservation;
      _loadingOrderObservation = false;
    });
  }

  // Vai direto para a última aba ("Resumo do pedido"), replicando o onTap da TabBar.
  void _goToResumo() {
    final last = tradingsProviderController.negotiations.length - 1;
    FocusScope.of(context).unfocus();
    tradingsProviderController.search("");
    tradingsProviderController.tabSelected = last;
    tradingsProviderController.tabController.animateTo(last);
    tradingsProviderController.itemTotal.value = StateApp.loading;
    tradingsProviderController.itemTotal.value = StateApp.success;
    tradingsProviderController.itemSelected.value = -1;
  }

  saveOrder() async {
    try {
      FocusScope.of(context).unfocus();
      await tradingsProviderController.insertInList(
        widget.codeBranch!,
        widget.codeProvider!,
        widget.codeClient!,
        widget.listBranchs!,
        widget.codeConsult!,
        orderObservation.text,
      );
      navigatorHome();
      tradingsProviderController.stateFinishTrading.value = StateApp.success;
    } catch (e) {
      debugPrint("Error saveOrder: $e");
      Fluttertoast.showToast(
          msg: "Pedido não foi salvo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  navigatorHome() {
    Navigator.of(context).pushNamed("/tradingsuccess", arguments: {
      "client": widget.codeClient,
      "consult": widget.codeConsult,
      "trading": 0,
      "provider": widget.codeProvider,
      "branch": widget.codeBranch,
      "clientModel": widget.client,
      "finishTradingController": finishTradingController,
      "value": formatCurrency(tradingsProviderController.totalValue),
      "hour": DateFormat.Hm().format(DateTime.now()).toString()
    });
  }

  int _lastTabIndex = 0;
  bool _tabListenerAdded = false;

  getFindTradingsProvider() async {
    await tradingsProviderController.findTradingsProvider(
        widget.codeBranch!, widget.codeProvider!);
    tradingsProviderController.tabController = TabController(
        vsync: this, length: tradingsProviderController.negotiations.length);
    tradingsProviderController.tabController.addListener(_onTabChanged);
    _tabListenerAdded = true;
  }

  // Rebuild ao mudar de aba para atualizar a visibilidade do botão flutuante.
  void _onTabChanged() {
    if (!mounted) return;
    final index = tradingsProviderController.tabController.index;
    if (index != _lastTabIndex) {
      _lastTabIndex = index;
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (_tabListenerAdded) {
      tradingsProviderController.tabController.removeListener(_onTabChanged);
    }
    orderObservation.dispose();
    orderObservationFocus.dispose();
    super.dispose();
  }

  // Botão flutuante "Resumo do pedido": visível em todas as abas exceto a última
  // (Resumo) e escondido quando o teclado está aberto.
  Widget? _buildResumoFab(BuildContext context) {
    if (!_settings.showFloatingButton) return null;
    final negotiations = tradingsProviderController.negotiations;
    if (negotiations.length < 2) return null;
    final last = negotiations.length - 1;
    final onResumo = tradingsProviderController.tabController.index == last;
    final keyboardUp = MediaQuery.of(context).viewInsets.bottom > 0;
    if (onResumo || keyboardUp) return null;
    return FloatingActionButton.extended(
      heroTag: 'resumoFab',
      backgroundColor: colorSecondary,
      foregroundColor: colorWhite,
      // Sobrescreve o CircleBorder do tema (que estava recortando o texto).
      shape: const StadiumBorder(),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 22),
      onPressed: _goToResumo,
      icon: const Icon(Icons.receipt_long_rounded),
      label: const Text("Resumo do pedido",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
    );
  }

  Widget _buildObservationCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasObservation = _savedOrderObservation.isNotEmpty;

    void openObservationEditor() {
      setState(() => _showObservationEditor = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        orderObservationFocus.requestFocus();
      });
    }

    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: appPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.08)),
          bottom:
              BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Observação",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ),
              if (_loadingOrderObservation)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colorSecondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    if (_showObservationEditor) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _savedOrderObservation = orderObservation.text.trim();
                        _showObservationEditor = false;
                      });
                      return;
                    }

                    openObservationEditor();
                  },
                  icon: Icon(
                    _showObservationEditor
                        ? Icons.keyboard_arrow_up
                        : Icons.edit_outlined,
                    size: 16,
                  ),
                  label: Text(
                    _showObservationEditor
                        ? "Fechar"
                        : hasObservation
                            ? "Editar"
                            : "Adicionar",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (!_showObservationEditor) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: openObservationEditor,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  hasObservation
                      ? _savedOrderObservation
                      : "Nenhuma observação adicionada.",
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: colorScheme.onSurface
                        .withValues(alpha: hasObservation ? 0.68 : 0.42),
                    fontStyle:
                        hasObservation ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
          if (_showObservationEditor) ...[
            const SizedBox(height: 10),
            TextField(
              controller: orderObservation,
              focusNode: orderObservationFocus,
              minLines: 3,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              inputFormatters: const [_ObservationTextFormatter()],
              decoration: InputDecoration(
                hintText: "Informe uma observação para este pedido",
                filled: false,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: colorScheme.onSurface.withValues(alpha: 0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: colorScheme.onSurface.withValues(alpha: 0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: colorSecondary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

// Intercepta a ação de voltar
  onPop(Size size) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appRadius),
          ),
          title: const Text('Deseja realmente sair?'),
          content: SizedBox(
              width: size.width * 1,
              child: const Text(
                  'Caso você volte as informações que foram digitadas serão perdidas, para que isso não aconteça finalize o pedido primeiro!')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final hideFinishButton =
        _showObservationEditor && MediaQuery.of(context).viewInsets.bottom > 0;
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        onPop(size);
      },
      child: ValueListenableBuilder(
          valueListenable: tradingsProviderController.stateRequest,
          builder: (context, value, child) {
            return value == StateApp.loading
                ? Scaffold(
                    body: LoadingList(
                      loadingHeader: false,
                    ),
                  )
                : value == StateApp.success
                    ? Scaffold(
                        appBar: AppBar(
                          leading: Container(),
                          actions: [
                            ValueListenableBuilder(
                              valueListenable:
                                  tradingsProviderController.itemTotal,
                              builder: (context, value, child) {
                                return HeaderActions(
                                  activeSearch:
                                      tradingsProviderController.tabSelected ==
                                              (tradingsProviderController
                                                      .negotiations.length -
                                                  1)
                                          ? false
                                          : true,
                                  label:
                                      tradingsProviderController.totalValue ==
                                                  0.0 ||
                                              (tradingsProviderController
                                                      .tabController.index ==
                                                  (tradingsProviderController
                                                          .negotiations.length -
                                                      1))
                                          ? "Negociações"
                                          : formatCurrency(
                                              tradingsProviderController
                                                  .totalValue),
                                  onSearch:
                                      tradingsProviderController.tabSelected ==
                                              (tradingsProviderController
                                                      .negotiations.length -
                                                  1)
                                          ? null
                                          : (value) {
                                              tradingsProviderController
                                                  .search(value);
                                            },
                                  alertClose: true,
                                  onSort:
                                      tradingsProviderController.tabSelected ==
                                              (tradingsProviderController
                                                      .negotiations.length -
                                                  1)
                                          ? null
                                          : () {
                                              tradingsProviderController.sort();
                                            },
                                  onCloseInfo: () {
                                    tradingsProviderController.updateTrading();
                                  },
                                  // Na aba "Resumo do pedido" (última), esconde voltar e configurações.
                                  activePop:
                                      tradingsProviderController.tabSelected !=
                                          (tradingsProviderController
                                                  .negotiations.length -
                                              1),
                                  onSettings:
                                      tradingsProviderController.tabSelected ==
                                              (tradingsProviderController
                                                      .negotiations.length -
                                                  1)
                                          ? null
                                          : () => _openSettings(),
                                  addIcon: history == 1
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  "/history-clients-tradings",
                                                  arguments: {
                                                    "provider":
                                                        widget.codeProvider,
                                                    "client": widget.codeBranch,
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.history_outlined)),
                                        )
                                      : null,
                                );
                              },
                            ),
                          ],
                          bottom: TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            onTap: (value) {
                              tradingsProviderController.search("");
                              FocusScope.of(context).unfocus();
                              tradingsProviderController.tabSelected = value;
                              tradingsProviderController.itemTotal.value =
                                  StateApp.loading;
                              tradingsProviderController.itemTotal.value =
                                  StateApp.success;
                              tradingsProviderController.itemSelected.value =
                                  -1;
                            },
                            controller:
                                tradingsProviderController.tabController,
                            indicatorColor: colorSecondary,
                            labelColor: colorSecondary,
                            tabs: tradingsProviderController.negotiations
                                .asMap()
                                .entries
                                .map((negotiation) {
                              final bool isLast = negotiation.key ==
                                  (tradingsProviderController
                                          .negotiations.length -
                                      1);
                              // Com o cabeçalho oculto, mostra a data da negociação na aba.
                              final String? tabDate =
                                  (_settings.hideHeader && !isLast)
                                      ? _formatTerm(negotiation.value.term)
                                      : null;
                              return Container(
                                padding: const EdgeInsets.all(appPadding),
                                width: isLast ? size.width * 0.97 : null,
                                child: Row(
                                  children: [
                                    Text("${negotiation.value.title}"),
                                    if (tabDate != null) ...[
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Text(
                                        tabDate,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                    if (negotiation.value.confirm != null)
                                      const SizedBox(width: 5),
                                    if (negotiation.value.confirm != null)
                                      Badge(
                                          alignment: Alignment.centerLeft,
                                          offset: Offset.fromDirection(3),
                                          backgroundColor: colorRed,
                                          smallSize: 8),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerFloat,
                        floatingActionButton: _buildResumoFab(context),
                        body: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tradingsProviderController.tabController,
                          children: tradingsProviderController.negotiations
                              .asMap()
                              .entries
                              .map((negotiation) {
                            return negotiation.key ==
                                    (tradingsProviderController
                                            .negotiations.length -
                                        1)
                                ? ValueListenableBuilder(
                                    valueListenable:
                                        tradingsProviderController.itemTotal,
                                    builder: (context, value, child) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    appPadding),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // ── Hero Card ────────────────────────────────────────────
                                                    Container(
                                                      width: double.maxFinite,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              appPadding + 4),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            colorSecondary,
                                                            colorPrimary
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    appRadius),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "RESUMO DO PEDIDO",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                          alpha:
                                                                              0.75),
                                                                  letterSpacing:
                                                                      1.2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                DateFormat.Hm()
                                                                    .format(DateTime
                                                                        .now()),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                          alpha:
                                                                              0.75),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            formatCurrency(
                                                                tradingsProviderController
                                                                    .totalValue),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 34,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing:
                                                                  -0.5,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .person_outline,
                                                                      size: 14,
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                              alpha: 0.75)),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  Text(
                                                                    "para ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .white
                                                                            .withValues(alpha: 0.7)),
                                                                  ),
                                                                  Text(
                                                                    "${widget.listBranchs!.first.nameUser}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                          alpha:
                                                                              0.15),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .inventory_2_outlined,
                                                                        size:
                                                                            14,
                                                                        color: Colors
                                                                            .white),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      "${tradingsProviderController.totalVolume} volumes",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const AppSpacing(),
                                                    _buildObservationCard(
                                                        context),
                                                    const AppSpacing(),

                                                    // ── Lojas selecionadas ────────────────────────────────
                                                    const Text(
                                                      "Lojas selecionadas",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    ValueListenableBuilder(
                                                        valueListenable:
                                                            tradingsProviderController
                                                                .stateTradings,
                                                        builder: (context,
                                                            value, child) {
                                                          return Column(
                                                            children: widget
                                                                .listBranchs!
                                                                .asMap()
                                                                .entries
                                                                .map((e) {
                                                              return e.value
                                                                      .checked!
                                                                  ? Container(
                                                                      width: double
                                                                          .maxFinite,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              8),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: colorSecondary.withValues(
                                                                            alpha:
                                                                                0.06),
                                                                        borderRadius:
                                                                            BorderRadius.circular(appRadius),
                                                                        border: Border.all(
                                                                            color:
                                                                                colorSecondary.withValues(alpha: 0.2)),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.store_outlined,
                                                                              size: 16,
                                                                              color: colorSecondary),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              e.value.documentCompany!,
                                                                              style: const TextStyle(fontSize: 13, color: colorSecondary, fontWeight: FontWeight.w500),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink();
                                                            }).toList(),
                                                          );
                                                        }),

                                                    // ── Duplicar para outras lojas ────────────────────────
                                                    if (widget.listBranchs!
                                                            .length >
                                                        1) ...[
                                                      const AppSpacing(),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      appRadius),
                                                          border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                    alpha:
                                                                        0.08),
                                                          ),
                                                        ),
                                                        child: ExpansionTile(
                                                          leading: Container(
                                                            width: 36,
                                                            height: 36,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: colorSecondary
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: const Icon(
                                                                Icons
                                                                    .store_outlined,
                                                                color:
                                                                    colorSecondary,
                                                                size: 18),
                                                          ),
                                                          title: const Text(
                                                            "Duplicar para outras lojas",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          subtitle: Text(
                                                            "Replique este pedido para filiais",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface
                                                                    .withValues(
                                                                        alpha:
                                                                            0.45)),
                                                          ),
                                                          tilePadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      appPadding,
                                                                  vertical: 4),
                                                          shape: const Border
                                                              .symmetric(
                                                              horizontal: BorderSide(
                                                                  color: Colors
                                                                      .transparent)),
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      appPadding,
                                                                      0,
                                                                      appPadding,
                                                                      appPadding),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Divider(
                                                                    height: 1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onSurface
                                                                        .withValues(
                                                                            alpha:
                                                                                0.08),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          appMargin),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .info_outline,
                                                                          size:
                                                                              13,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onSurface
                                                                              .withValues(alpha: 0.4)),
                                                                      const SizedBox(
                                                                          width:
                                                                              6),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          "O pedido será replicado para as filiais selecionadas.",
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          appPadding),
                                                                  Column(
                                                                    children: widget
                                                                        .listBranchs!
                                                                        .asMap()
                                                                        .entries
                                                                        .map(
                                                                      (e) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (e.value.checked! &&
                                                                                tradingsProviderController.totalCheckedBranch > 1) {
                                                                              tradingsProviderController.totalCheckedBranch -= 1;
                                                                              widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                            } else if (e.value.checked! == false) {
                                                                              tradingsProviderController.totalCheckedBranch += 1;
                                                                              widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                            }
                                                                            tradingsProviderController.updateTrading();
                                                                          },
                                                                          borderRadius:
                                                                              BorderRadius.circular(appRadius),
                                                                          child:
                                                                              ValueListenableBuilder(
                                                                            valueListenable:
                                                                                tradingsProviderController.stateTradings,
                                                                            builder: (context,
                                                                                bool stateValue,
                                                                                child) {
                                                                              return AnimatedContainer(
                                                                                duration: const Duration(milliseconds: 180),
                                                                                margin: const EdgeInsets.only(bottom: 8),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                                decoration: BoxDecoration(
                                                                                  color: e.value.checked! ? colorSecondary.withValues(alpha: 0.07) : Theme.of(context).colorScheme.background.withValues(alpha: 0.03),
                                                                                  borderRadius: BorderRadius.circular(appRadius),
                                                                                  border: Border.all(
                                                                                    color: e.value.checked! ? colorSecondary.withValues(alpha: 0.35) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07),
                                                                                    width: e.value.checked! ? 1.5 : 1,
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 32,
                                                                                      height: 32,
                                                                                      decoration: BoxDecoration(
                                                                                        color: e.value.checked! ? colorSecondary.withValues(alpha: 0.15) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        e.value.checked! ? Icons.store : Icons.store_outlined,
                                                                                        size: 15,
                                                                                        color: e.value.checked! ? colorSecondary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 12),
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            '${e.value.nameCompany}',
                                                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                          ),
                                                                                          Text(
                                                                                            '${e.value.relationshipCode}',
                                                                                            style: TextStyle(
                                                                                              fontSize: 11,
                                                                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Checkbox(
                                                                                      activeColor: colorSecondary,
                                                                                      value: e.value.checked,
                                                                                      side: const BorderSide(color: colorGrey),
                                                                                      shape: const RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                                      ),
                                                                                      onChanged: (value) {
                                                                                        if (e.value.checked! && tradingsProviderController.totalCheckedBranch > 1) {
                                                                                          tradingsProviderController.totalCheckedBranch -= 1;
                                                                                          widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                                        } else if (e.value.checked! == false) {
                                                                                          tradingsProviderController.totalCheckedBranch += 1;
                                                                                          widget.listBranchs![e.key].checked = !e.value.checked!;
                                                                                        }
                                                                                        tradingsProviderController.updateTrading();
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],

                                                    const AppSpacing(),
                                                    Divider(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withValues(
                                                                alpha: 0.1)),
                                                    const AppSpacing(),

                                                    // ── Negociações ───────────────────────────────────────
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Negociações",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        Tooltip(
                                                          message:
                                                              "Clique na negociação e navegue até a aba para confirmar os itens pedidos.",
                                                          child: Icon(
                                                            Icons.info_outline,
                                                            size: 18,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface
                                                                .withValues(
                                                                    alpha: 0.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          tradingsProviderController
                                                              .negotiationResume
                                                              .map(
                                                                  (negotiation) {
                                                        return InkWell(
                                                          onTap: () {
                                                            // search index position negotiation per id and navigate to tab
                                                            int index = tradingsProviderController
                                                                .negotiations
                                                                .indexWhere((element) =>
                                                                    element
                                                                        .negotiation ==
                                                                    negotiation
                                                                        .negotiation);
                                                            if (index != -1) {
                                                              tradingsProviderController
                                                                  .tabController
                                                                  .animateTo(
                                                                      index);
                                                              tradingsProviderController
                                                                  .itemSelected
                                                                  .value = index;
                                                              tradingsProviderController
                                                                      .tabSelected =
                                                                  index;
                                                              tradingsProviderController
                                                                  .tabController
                                                                  .index = index;
                                                              tradingsProviderController
                                                                  .updateTrading();
                                                            }
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      appRadius),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        appMargin),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          appRadius),
                                                              border:
                                                                  Border.all(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface
                                                                    .withValues(
                                                                        alpha:
                                                                            0.08),
                                                              ),
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface
                                                                  .withValues(
                                                                      alpha:
                                                                          0.03),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 4,
                                                                  height: 68,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        colorSecondary,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              appRadius),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              appRadius),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            12),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${negotiation.negotiation} · ${negotiation.title}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Theme.of(context).colorScheme.onSurface,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                6),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.inventory_2_outlined,
                                                                                size: 13,
                                                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                                                                            const SizedBox(width: 4),
                                                                            Text(
                                                                              "${negotiation.volume} itens",
                                                                              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                                                                            ),
                                                                            const SizedBox(width: 16),
                                                                            Text(
                                                                              formatCurrency(negotiation.value),
                                                                              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              12),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 13,
                                                                    color: colorSecondary
                                                                        .withValues(
                                                                            alpha:
                                                                                0.6),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),

                                                    const AppSpacing(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (!hideFinishButton)
                                            // ── Finalizar Pedido (footer fixo) ───────────────────
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      appPadding,
                                                      appPadding,
                                                      appPadding,
                                                      appPadding),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                border: Border(
                                                  top: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(
                                                            alpha: 0.08),
                                                  ),
                                                ),
                                              ),
                                              child: SafeArea(
                                                top: false,
                                                child: ValueListenableBuilder(
                                                  valueListenable:
                                                      tradingsProviderController
                                                          .stateFinishTrading,
                                                  builder:
                                                      (context, value, child) {
                                                    // Só habilita finalizar quando o resumo tem valor (> 0).
                                                    final bool canFinish =
                                                        tradingsProviderController
                                                                .totalValue >
                                                            0;
                                                    return AppButton(
                                                      label: "Finalizar Pedido",
                                                      colorButton: canFinish
                                                          ? colorSecondary
                                                          : colorGrey,
                                                      state:
                                                          tradingsProviderController
                                                              .stateFinishTrading
                                                              .value,
                                                      iconButton:
                                                          Icons.done_all,
                                                      loading: value ==
                                                          StateApp.loading,
                                                      onPressButton: canFinish
                                                          ? () {
                                                              saveOrder();
                                                            }
                                                          : null,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    })
                                : ComponentList(
                                    tradingsProviderController:
                                        tradingsProviderController,
                                    negotiation: negotiation.value,
                                    index: negotiation.key,
                                    codeBranch: widget.codeBranch!,
                                    codeClient: widget.codeClient!,
                                    listBranchs: widget.listBranchs,
                                    compactHeader: _settings.compactHeader,
                                    showTagFilters: _settings.tagFilters,
                                    simpleProductInfo:
                                        _settings.simpleProductInfo,
                                    hideHeader: _settings.hideHeader,
                                  );
                          }).toList(),
                        ),
                      )
                    : Container();
          }),
    );
  }
}
