import 'dart:async';
import 'package:profair/src/repositories/campaign_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CardNotice extends StatefulWidget {
  const CardNotice({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<CardNotice> createState() => _CardNoticeState();
}

class _CardNoticeState extends State<CardNotice> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  List<CampaignModel> get _campaigns {
    final list = widget.homeController.campaigns;
    return list.isNotEmpty ? list : [if (widget.homeController.campaign != null) widget.homeController.campaign!];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (_campaigns.length <= 1) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % _campaigns.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = _campaigns;
    if (campaigns.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _pageController,
              itemCount: campaigns.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _SlideCard(
                  campaign: campaigns[index],
                  homeController: widget.homeController,
                );
              },
            ),
          ),
          if (campaigns.length > 1) ...[
            const SizedBox(height: 10),
            _PageIndicator(
              count: campaigns.length,
              current: _currentPage,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Slide individual ────────────────────────────────────────────────────────

class _SlideCard extends StatelessWidget {
  const _SlideCard({required this.campaign, required this.homeController});

  final CampaignModel campaign;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    final cardColor = Color(int.parse(campaign.secondaryColor ?? "0xFF1a1a2e"));
    final accentColor = Color(int.parse(campaign.primaryColor ?? "0xFF6e41ff"));
    final hasImage = campaign.image != null && campaign.image!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // final action = campaign.action;
            // if (action != null && action.isNotEmpty) {
            //   final uri = Uri.parse(action);
            //   if (await canLaunchUrl(uri)) {
            //     await launchUrl(uri, mode: LaunchMode.externalApplication);
            //     return;
            //   }
            // }
            if (context.mounted) {
              Navigator.of(context)
                  .pushNamed("/detailsnotice", arguments: {"id": campaign.code, "codeBranch": homeController.data!.codCompany, "accessTargeting": homeController.data!.accessTargeting});
            }
          },
          splashColor: Colors.white.withValues(alpha: 0.08),
          highlightColor: Colors.white.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: cardColor,
              image: hasImage
                  ? DecorationImage(
                      image: NetworkImage(campaign.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Scrim para legibilidade
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: hasImage
                            ? [
                                Colors.black.withValues(alpha: 0.05),
                                Colors.black.withValues(alpha: 0.72),
                              ]
                            : [
                                cardColor.withValues(alpha: 0.0),
                                cardColor.withValues(alpha: 0.6),
                              ],
                        stops: const [0.25, 1.0],
                      ),
                    ),
                  ),
                ),

                // Barra de accent lateral (sem imagem)
                if (!hasImage)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4, color: accentColor),
                  ),

                // Conteúdo
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge de evento
                      if ((campaign.stamp ?? '').isNotEmpty) _StampBadge(label: campaign.stamp!, color: accentColor),

                      // Texto + CTA
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((campaign.title ?? '').isNotEmpty)
                            Text(
                              campaign.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                color: colorWhite,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                          if ((campaign.description ?? '').isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              campaign.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorWhite.withValues(
                                  alpha: 0.9,
                                ),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Badge de evento ─────────────────────────────────────────────────────────

class _StampBadge extends StatelessWidget {
  const _StampBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: colorWhite,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: colorWhite,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Indicador de página ─────────────────────────────────────────────────────

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: isActive ? 20 : 6,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
