import 'package:intl/intl.dart';
import 'package:profair/src/controllers/tradings_controller.dart';
import 'package:profair/src/repositories/tradings_repository.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

class ReorderTradings extends StatefulWidget {
  const ReorderTradings({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<ReorderTradings> createState() => _ReorderTradingsState();
}

class _ReorderTradingsState extends State<ReorderTradings> {
  final TradingsController tradingsController = TradingsController(StateApp.start, TradingsRepository());

  @override
  void initState() {
    tradingsController.findTradings(widget.homeController.data!.codCompany.toString());
    super.initState();
  }

  Future<void> _persistOrder() async {
    final success = await tradingsController.saveOrder();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Ordem salva com sucesso" : "Não foi possível salvar a ordem"),
        backgroundColor: success ? colorSecondary : colorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderList(
              icon: Icons.swap_horiz_rounded,
              label: "Ordenar Negociações",
              activeSearch: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.drag_indicator_rounded, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Arraste os cards para definir a ordem de exibição",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: tradingsController.stateTradings,
                builder: (context, value, child) {
                  if (value == StateApp.loading) {
                    return LoadingList(icon: Icons.swap_horiz_rounded, label: "Negociações");
                  }

                  final items = tradingsController.tradingList.toList();

                  return ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 8),
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        tradingsController.reorder(oldIndex, newIndex);
                      });
                      _persistOrder();
                    },
                    proxyDecorator: (child, index, animation) {
                      // Feedback visual: o card encolhe levemente e flutua com sombra suave
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          final double t = Curves.easeInOut.transform(animation.value);
                          final double scale = 1 - (0.05 * t);
                          return Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: 1 - (0.06 * t),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(appRadius),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.18 * t),
                                      blurRadius: 24,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: child,
                      );
                    },
                    itemBuilder: (context, index) {
                      final e = items[index];
                      final bool hasVolume = e.totalVolume != "0";
                      final Color accentColor = hasVolume ? colorSecondary : colorGreyDark;

                      return Padding(
                        key: ValueKey(e.code),
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(appRadius),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(appRadius),
                            onTap: () {
                              Navigator.of(context).pushNamed('negotiationproducts', arguments: {
                                "codeProvider": e.provider,
                                "codeTrading": e.code,
                                "title": e.title,
                              });
                            },
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(appRadius),
                                color: Theme.of(context).colorScheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(appRadius),
                                child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: 4,
                                    color: accentColor,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: accentColor.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'Nº ${e.code}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: accentColor,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.drag_indicator_rounded,
                                                size: 22,
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${e.title}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                              color: Theme.of(context).colorScheme.onSurface,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_rounded,
                                                size: 13,
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateFormat("dd/MM/yyyy").format(DateTime.parse(e.term!)),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
