import 'package:profair/src/controllers/providers_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.codeProvider,
    required this.providersController,
    required this.codeClient,
    required this.codeBranch,
  });

  Iterable<ProvidersModel> listItems;
  final String? description;
  final ValueListenable state;
  final int? codeProvider;
  final ProvidersController providersController;
  final int? codeClient;
  final int? codeBranch;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  int selling = 0;

  @override
  void initState() {
    super.initState();
    widget.providersController.findMap();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(icon: Icons.groups_2_sharp, label: widget.description),
      component: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderList(
            onSortMenu: (p0) {
              widget.providersController.sort(p0);
            },
            icon: Icons.groups_2_sharp,
            onSearch: (String? value) {
              widget.providersController.search(value);
            },
            // onSort: () {
            //   widget.providersController.sort();
            // },
            label: "Fornecedores",
          ),

          // Banner mapa do evento
          ValueListenableBuilder(
            valueListenable: widget.providersController.stateMap,
            builder: (context, stateM, child) {
              if (stateM == StateApp.loading) {
                return const Skeletonizer(
                  child: SizedBox(height: 72, width: double.infinity),
                );
              }
              final hasMap = widget.providersController.mapUrl != null && widget.providersController.mapUrl != "null" && widget.providersController.mapUrl != "";
              if (!hasMap) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        "mapevent",
                        arguments: {"map": widget.providersController.mapUrl},
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            colorSecondary.withValues(alpha: 0.12),
                            colorPrimary.withValues(alpha: 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: colorSecondary.withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorSecondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.map_outlined, color: colorSecondary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Mapa do evento",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: colorSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Veja a localização dos stands",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: colorSecondary.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Chips de filtro
          ValueListenableBuilder(
            valueListenable: widget.providersController.stateProviders,
            builder: (context, stateSell, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: "Todos",
                        count: widget.providersController.sellCounts[0],
                        isActive: selling == 0,
                        onTap: () {
                          setState(() => selling = 0);
                          widget.providersController.providerSelling(0);
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: "Com pedido",
                        count: widget.providersController.sellCounts[1],
                        isActive: selling == 2,
                        activeColor: const Color(0xFF22C55E),
                        dotColor: const Color(0xFF22C55E),
                        onTap: () {
                          setState(() => selling = 2);
                          widget.providersController.providerSelling(2);
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: "Sem pedido",
                        count: widget.providersController.sellCounts[2],
                        isActive: selling == 1,
                        activeColor: colorPrimary,
                        onTap: () {
                          setState(() => selling = 1);
                          widget.providersController.providerSelling(1);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Lista de fornecedores
          ValueListenableBuilder(
            valueListenable: widget.providersController.stateSearchProviders,
            builder: (context, value, child) {
              final providers = widget.providersController.providersList.toList();
              if (providers.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 40, color: colorGrey),
                        SizedBox(height: 8),
                        Text(
                          "Nenhum fornecedor encontrado",
                          style: TextStyle(color: colorGreyDark, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: providers
                    .map((e) => _ProviderCard(
                          provider: e,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              "detailsprovider",
                              arguments: {
                                "codeProvider": e.codeProvider,
                                "imageProvider": e.image,
                                "nameProvider": e.nameProvider,
                                "codeBranch": widget.codeBranch,
                                "color": e.color,
                              },
                            );
                          },
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Filter Chip ─────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.dotColor,
  });

  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? colorSecondary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? active.withValues(alpha: 0.15) : onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isActive ? active.withValues(alpha: 0.6) : onSurface.withValues(alpha: 0.12),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive && dotColor != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? active : onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isActive ? active.withValues(alpha: 0.2) : onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive ? active : onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Provider Card ────────────────────────────────────────────────────────────

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider, required this.onTap});

  final ProvidersModel provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasSale = provider.totalValue != null && provider.totalValue! > 0.0;
    final brandColor = provider.color != null ? Color(int.parse(provider.color!)) : colorTertiary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Avatar com ring de status
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandColor.withValues(alpha: 0.12),
                      border: Border.all(
                        color: hasSale ? const Color(0xFF22C55E) : brandColor.withValues(alpha: 0.4),
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: provider.image != null
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                provider.image!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => _InitialsAvatar(
                                  name: provider.nameProvider ?? "",
                                  color: brandColor,
                                ),
                              ),
                            )
                          : _InitialsAvatar(name: provider.nameProvider ?? "", color: brandColor),
                    ),
                  ),
                  if (hasSale)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 14),

              // Informações do fornecedor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            provider.nameProvider ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: onSurface,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge de valor
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: hasSale ? const Color(0xFF22C55E).withValues(alpha: 0.12) : onSurface.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formatCurrency(provider.totalValue ?? 0.0),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: hasSale ? const Color(0xFF22C55E) : onSurface.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          "Cód. ${provider.codeProvider}",
                          style: TextStyle(
                            fontSize: 12,
                            color: onSurface.withValues(alpha: 0.45),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: onSurface.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hasSale ? "Pedido realizado" : "Sem pedido",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: hasSale ? const Color(0xFF22C55E).withValues(alpha: 0.9) : onSurface.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: onSurface.withValues(alpha: 0.25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Initials Avatar ──────────────────────────────────────────────────────────

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name, required this.color});

  final String name;
  final Color color;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}
