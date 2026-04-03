import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/repositories/notice_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ComponentDetails extends StatefulWidget {
  const ComponentDetails({
    super.key,
    required this.homeController,
    required this.codeBranch,
    required this.accessTargeting,
  });

  final HomeController homeController;
  final int codeBranch;
  final int accessTargeting;

  @override
  State<ComponentDetails> createState() => _ComponentDetailsState();
}

class _ComponentDetailsState extends State<ComponentDetails> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _parseColor(String? hex, Color fallback) {
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

  String _priorityLabel(int? p) {
    switch (p) {
      case 1:
        return 'Baixa';
      case 2:
        return 'Média';
      case 3:
        return 'Alta';
      default:
        return 'Normal';
    }
  }

  Color _priorityColor(int? p) {
    switch (p) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return colorGreyDark;
    }
  }

  String _typeLabel(int? t) {
    switch (t) {
      case 1:
        return 'Aviso';
      case 2:
        return 'Promoção';
      case 3:
        return 'Evento';
      case 4:
        return 'Novidade';
      default:
        return 'Comunicado';
    }
  }

  IconData _typeIcon(int? t) {
    switch (t) {
      case 1:
        return Icons.info_outline_rounded;
      case 2:
        return Icons.local_offer_outlined;
      case 3:
        return Icons.event_outlined;
      case 4:
        return Icons.auto_awesome_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  Future<void> _launchAction(String? action) async {
    print("Launching action: $action");
    if (action == null || action.isEmpty) return;
    final uri = Uri.parse(action);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StateApp>(
      valueListenable: widget.homeController.stateNotice,
      builder: (context, state, _) {
        if (state == StateApp.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(child: LoadingList(loadingHeader: false)),
          );
        }

        if (state != StateApp.success || widget.homeController.notice == null) {
          return const SizedBox.shrink();
        }

        if (!_animController.isCompleted) {
          _animController.forward();
        }

        final notice = widget.homeController.notice!;
        final primary = _parseColor(notice.primaryColor, colorPrimary);
        final secondary = _parseColor(notice.secondaryColor, colorSecondary);

        if (state == StateApp.success && notice.provider != null && notice.provider != 0) {
          widget.homeController.getProvider(notice.provider!);
        }

        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroHeader(
                notice: notice,
                primary: primary,
                secondary: secondary,
                typeIcon: _typeIcon(notice.type),
              ),
              SlideTransition(
                position: _slideAnim,
                child: _ContentSection(
                  codeBranch: widget.codeBranch,
                  accessTargeting: widget.accessTargeting,
                  homeController: widget.homeController,
                  notice: notice,
                  primary: primary,
                  secondary: secondary,
                  priorityLabel: _priorityLabel(notice.priority),
                  priorityColor: _priorityColor(notice.priority),
                  typeLabel: _typeLabel(notice.type),
                  typeIcon: _typeIcon(notice.type),
                  onAction: () => _launchAction(notice.action),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.notice,
    required this.primary,
    required this.secondary,
    required this.typeIcon,
  });

  final NoticeModel notice;
  final Color primary;
  final Color secondary;
  final IconData typeIcon;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 300 + topPadding,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, secondary],
              ),
            ),
          ),

          // Network image
          if (notice.image != null && notice.image!.isNotEmpty)
            Image.network(
              notice.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),

          // Bottom fade overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.35, 1.0],
                  colors: [
                    Colors.transparent,
                    primary.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),

          // Decorative watermark icon when no image
          if (notice.image == null || notice.image!.isEmpty)
            Positioned(
              right: -20,
              bottom: 40,
              child: Opacity(
                opacity: 0.12,
                child: Icon(typeIcon, size: 200, color: Colors.white),
              ),
            ),

          // Back button
          Positioned(
            top: topPadding + 8,
            left: appPadding,
            child: _GlassButton(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),

          // Stamp badge
          if (notice.stamp != null && notice.stamp!.isNotEmpty)
            Positioned(
              top: topPadding + 8,
              right: appPadding,
              child: _GlassButton(
                padding: const EdgeInsets.all(6),
                child: Image.network(
                  notice.stamp!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),

          // Title at bottom of hero
          Positioned(
            left: appPadding,
            right: appPadding,
            bottom: appPadding * 1.5,
            child: Text(
              notice.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.4,
                shadows: [
                  Shadow(
                    blurRadius: 12,
                    color: Colors.black38,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.notice,
    required this.primary,
    required this.secondary,
    required this.priorityLabel,
    required this.priorityColor,
    required this.typeLabel,
    required this.typeIcon,
    required this.onAction,
    required this.homeController,
    required this.codeBranch,
    required this.accessTargeting,
  });

  final NoticeModel notice;
  final Color primary;
  final Color secondary;
  final String priorityLabel;
  final Color priorityColor;
  final String typeLabel;
  final IconData typeIcon;
  final VoidCallback onAction;
  final HomeController homeController;
  final int codeBranch;
  final int accessTargeting;

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(appPadding, appPadding * 1.5, appPadding, appPadding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BadgeChip(label: typeLabel, icon: typeIcon, color: primary),
              _BadgeChip(
                label: priorityLabel,
                icon: Icons.flag_rounded,
                color: priorityColor,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Accent line
          Container(
            height: 3,
            width: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primary, secondary]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),
          if (accessTargeting == 2)
            ValueListenableBuilder(
              valueListenable: homeController.stateProvider,
              builder: (context, state, child) {
                if (state != StateApp.success) return const SizedBox.shrink();
                final provider = homeController.provider;
                final providerColor = _parseColor.call(provider?.color, colorPrimary);
                return GestureDetector(
                  onTap: () => Modular.to.pushNamed(
                    "detailsprovider",
                    arguments: {
                      "imageProvider": provider?.image ?? '',
                      "color": provider?.color,
                      "nameProvider": provider?.socialName ?? '',
                      "codeBranch": codeBranch,
                      "codeProvider": provider?.codeProvider,
                    },
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(appPadding),
                    decoration: BoxDecoration(
                      color: providerColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(appRadius),
                      border: Border.all(
                        color: providerColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (provider?.image != null && provider!.image!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              provider.image!,
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
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                provider?.nameProvider ?? provider?.socialName ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: colorGreyDark,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (provider?.socialName != null && provider!.socialName!.isNotEmpty)
                                Text(
                                  provider.socialName!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorGreyDark.withValues(alpha: 0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: providerColor, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 20),

          // Description
          if (notice.description != null && notice.description!.isNotEmpty)
            Text(
              notice.description!,
              style: const TextStyle(
                fontSize: 16,
                color: colorGreyDark,
                height: 1.75,
                letterSpacing: 0.1,
              ),
            ),

          const SizedBox(height: 32),

          // Meta info row
          // _MetaRow(notice: notice, primary: primary),

          // CTA button
          if (notice.action != null && notice.action!.isNotEmpty)
            _ActionButton(
              primary: primary,
              secondary: secondary,
              onTap: onAction,
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

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
// ---------------------------------------------------------------------------

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.notice, required this.primary});

  final NoticeModel notice;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    if (notice.code == null && notice.priority == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(appRadius),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (notice.code != null) ...[
            Icon(Icons.tag_rounded, size: 16, color: primary),
            const SizedBox(width: 6),
            Text(
              '#${notice.code}',
              style: TextStyle(
                fontSize: 13,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const Spacer(),
          if (notice.priority != null) ...[
            Icon(Icons.bar_chart_rounded, size: 16, color: primary),
            const SizedBox(width: 4),
            Text(
              'Prioridade ${notice.priority}',
              style: TextStyle(
                fontSize: 13,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.primary,
    required this.secondary,
    required this.onTap,
  });

  final Color primary;
  final Color secondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(appRadius),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_outward_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Saiba mais',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.storefront_outlined, color: color, size: 26),
    );
  }
}

// ---------------------------------------------------------------------------

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.child,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding ?? const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
