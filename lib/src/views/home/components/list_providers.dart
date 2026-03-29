import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class ListProviders extends StatefulWidget {
  const ListProviders({
    super.key,
    this.description,
    required this.homeController,
  });

  final String? description;
  final HomeController homeController;

  @override
  State<ListProviders> createState() => _ListProvidersState();
}

class _ListProvidersState extends State<ListProviders> {
  @override
  void initState() {
    super.initState();
    widget.homeController.findTopProviders();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: widget.homeController.stateTopProvider,
      builder: (context, state, child) {
        return StateManagement(
          width: width,
          listenable: widget.homeController.stateTopProvider,
          widgetLoading: _buildSkeleton(width),
          component: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              widget.homeController.topProviders.isEmpty ? _buildEmptyState(context) : _buildList(context),
            ],
          ),
        );
      },
    );
  }

  // ── Skeleton ──────────────────────────────────
  Widget _buildSkeleton(double width) {
    return SizedBox(
      height: 178,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        itemCount: 4,
        itemBuilder: (_, __) => Skeletonizer(
          effect: const ShimmerEffect(),
          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  // ── Cabeçalho ─────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.description ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              "selectprovider",
              arguments: {
                "codeClient": 0,
                "codeBuyer": 0,
                "codeBranch": widget.homeController.data!.codCompany,
              },
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Ver todos",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Estado vazio ──────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: 20),
      child: Text(
        "Nenhum fornecedor encontrado",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  // ── Lista horizontal ──────────────────────────
  Widget _buildList(BuildContext context) {
    final providers = widget.homeController.topProviders;
    return SizedBox(
      height: 178,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final p = providers[index];
          final providerColor = p.color != null ? Color(int.parse(p.color!)) : colorPrimary;
          final isLast = index == providers.length - 1;
          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              "detailsprovider",
              arguments: {
                "codeProvider": p.codeProvider,
                "imageProvider": p.image,
                "nameProvider": p.nameProvider,
                "codeBranch": widget.homeController.data!.codCompany,
                "color": p.color,
              },
            ),
            child: Container(
              width: 170,
              margin: EdgeInsets.only(right: isLast ? 0 : 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Área da imagem
                  Container(
                    height: 96,
                    decoration: BoxDecoration(
                      color: providerColor.withValues(alpha: 0.9),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    ),
                    child: Center(
                      child: p.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                p.image!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => _providerInitial(p.nameProvider, providerColor),
                              ),
                            )
                          : _providerInitial(p.nameProvider, providerColor),
                    ),
                  ),

                  // Informações
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            p.nameProvider ?? "-",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  formatCurrency(p.totalValue ?? 0),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF10B981),
                                  ),
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
          );
        },
      ),
    );
  }

  Widget _providerInitial(String? name, Color color) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          name?.isNotEmpty == true ? name![0].toUpperCase() : "?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
