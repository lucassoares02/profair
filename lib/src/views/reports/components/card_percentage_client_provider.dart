import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:profair/src/controllers/clients_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardPercentageClientsProvider extends StatefulWidget {
  CardPercentageClientsProvider({
    super.key,
    required this.clientsController,
    required this.title,
    this.content,
    required this.value,
    this.backgroundColor = colorBlueDark,
    required this.footer,
  });

  ClientsController clientsController;
  String? title;
  String? content;
  String? value;
  String? footer;
  Color? backgroundColor;

  @override
  State<CardPercentageClientsProvider> createState() => _CardPercentageClientsProviderState();
}

class _CardPercentageClientsProviderState extends State<CardPercentageClientsProvider> {
  bool visibleContent = false;

  @override
  Widget build(BuildContext context) {
    // Safe parse with fallback — avoids FormatException on null/invalid values
    final percent = double.tryParse('${widget.value}') ?? 0.0;
    final percentClamped = (percent / 100).clamp(0.0, 1.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => visibleContent = !visibleContent),
        // Rounded splash matches card shape
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        splashColor: Colors.white12,
        highlightColor: Colors.white10,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: widget.backgroundColor,
            // Colour-tinted shadow gives depth without heavy elevation
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? colorBlueDark).withValues(alpha: 0.40),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: title + animated collapse chevron ─────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.title}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: colorWhite,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    // Chevron rotates 180° to signal expand/collapse state
                    AnimatedRotation(
                      turns: visibleContent ? 0 : 0.5,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.white60,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                // ── Optional content — animates height smoothly ───────────
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: visibleContent && widget.content != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '${widget.content}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              height: 1.45,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                // ── Progress bar + footer ─────────────────────────────────
                ValueListenableBuilder(
                  valueListenable: widget.clientsController.statePercentageClients,
                  builder: (context, value, child) {
                    if (value == StateApp.loading) {
                      // Skeleton mirrors real layout: bar then label
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Skeletonizer(
                            effect: const ShimmerEffect(),
                            child: Container(
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Skeletonizer(
                            effect: const ShimmerEffect(),
                            child: Container(
                              height: 12,
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Footer label and percentage on the same row for
                        // better scannability — no need to read the bar first
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.footer}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                letterSpacing: 0.1,
                              ),
                            ),
                            Text(
                              '${percent.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 13,
                                color: colorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Bar height grows slightly when content is collapsed
                        // so there is still a strong visual anchor
                        LinearPercentIndicator(
                          animation: true,
                          animationDuration: 600,
                          padding: EdgeInsets.zero,
                          lineHeight: visibleContent ? 8 : 10,
                          barRadius: const Radius.circular(6),
                          percent: percentClamped,
                          backgroundColor: Colors.white24,
                          progressColor: colorWhite,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
