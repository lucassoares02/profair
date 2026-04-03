import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:profair/src/components/button.dart';
import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComponentDetails extends StatefulWidget {
  ComponentDetails({
    super.key,
    required this.homeController,
  });

  HomeController homeController;

  @override
  State<ComponentDetails> createState() => _ComponentDetailsState();
}

class _ComponentDetailsState extends State<ComponentDetails> {
  String acessTargeting = "";
  String codeBranch = "";

  @override
  void initState() {
    loadSharedPreserences();
  }

  loadSharedPreserences() async {
    final prefs = await SharedPreferences.getInstance();
    acessTargeting = prefs.getString("direct").toString();
    codeBranch = prefs.getString("company").toString();
  }

  @override
  Widget build(BuildContext context) {
    final providerColor = _parseColor.call(widget.homeController.notification?.color, colorPrimary);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderList(
            activeSearch: false,
            label: "Detalhes",
          ),
          ValueListenableBuilder(
            valueListenable: widget.homeController.stateNotification,
            builder: (context, stateNotification, child) {
              if (stateNotification == StateApp.loading) {
                return LoadingList(loadingHeader: false);
              }
              if (stateNotification != StateApp.success) {
                return Container();
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero banner ──────────────────────────────────────
                    _HeroBanner(
                      notification: widget.homeController.notification!,
                    ),

                    const SizedBox(height: 20),

                    // ── Target type badge ────────────────────────────────
                    _TargetBadge(
                      target: widget.homeController.notification!.target,
                    ),

                    const SizedBox(height: 14),

                    // ── Title ────────────────────────────────────────────
                    Text(
                      widget.homeController.notification!.title!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.25,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Divider ──────────────────────────────────────────
                    Divider(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .08),
                      thickness: 1,
                      height: 1,
                    ),

                    const SizedBox(height: 16),

                    // ── Body content ─────────────────────────────────────
                    Text(
                      widget.homeController.notification!.content!,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.65,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .75),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // ── Provider card ────────────────────────────────────
                    if (widget.homeController.notification!.provider != 0 && acessTargeting == '2' && codeBranch != "") ...[
                      const SizedBox(height: 24),
                      Divider(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .08),
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(height: 20),
                      const _SectionLabel(label: "Fornecedor vinculado"),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Modular.to.pushNamed(
                          "detailsprovider",
                          arguments: {
                            "imageProvider": widget.homeController.notification!.imageProvider ?? '',
                            "color": widget.homeController.notification!.color,
                            "nameProvider": widget.homeController.notification!.nameProvider ?? '',
                            "codeBranch": codeBranch != "" ? int.parse(codeBranch) : 0,
                            "codeProvider": widget.homeController.notification!.provider,
                          },
                        ),
                        child: _ProviderCard(
                          notification: widget.homeController.notification!,
                          providerColor: providerColor,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.notification});

  final dynamic notification;

  @override
  Widget build(BuildContext context) {
    final bgColor = notification.color != null ? Color(int.parse(notification.color!)) : Colors.red;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.maxFinite,
        height: 200,
        color: bgColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // subtle gradient overlay for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bgColor.withValues(alpha: 0.4),
                    bgColor.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(appPadding * 2),
              child: Image.network(
                notification.imageProvider != null ? notification.imageProvider! : "https://drive.google.com/uc?export=view&id=1CXbRVXo5QkrjV960dYFfLlrmpf5TfwT-",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TargetBadge extends StatelessWidget {
  const _TargetBadge({required this.target});

  final dynamic target;

  static const _labels = {
    2: "Associados",
    1: "Fornecedores",
  };

  static const _icons = {
    2: Icons.people_outline,
    1: Icons.storefront_outlined,
  };

  static const _colors = {
    2: Color(0xFF22C55E), // green
    1: Color(0xFF3B82F6), // blue
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[target] ?? "Organizadores";
    final icon = _icons[target] ?? Icons.apartment_outlined;
    final color = _colors[target] ?? colorPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.link_outlined,
          size: 14,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .4),
        ),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .45),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.notification,
    required this.providerColor,
  });

  final dynamic notification;
  final Color providerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: providerColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: providerColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (notification.imageProvider != null && notification.imageProvider!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                notification.imageProvider!,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ProviderAvatarFallback(color: providerColor),
              ),
            )
          else
            _ProviderAvatarFallback(color: providerColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fornecedor',
                  style: TextStyle(
                    fontSize: 11,
                    color: providerColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  notification.nameProvider ?? notification.nameProvider ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (notification.nameProvider != null && notification.nameProvider!.isNotEmpty)
                  Text(
                    notification.nameProvider!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: providerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.arrow_forward_ios_rounded, color: providerColor, size: 14),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ProviderAvatarFallback extends StatelessWidget {
  const _ProviderAvatarFallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.storefront_outlined, color: color, size: 26),
    );
  }
}

// ---------------------------------------------------------------------------

class _parseColor {
  static Color call(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      try {
        return Color(int.parse(hex));
      } catch (_) {
        return fallback;
      }
    }
  }
}
