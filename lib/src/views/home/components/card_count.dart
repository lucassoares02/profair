import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardCount extends StatefulWidget {
  CardCount({super.key, required this.homeController});

  HomeController homeController;

  @override
  State<CardCount> createState() => _CardCountState();
}

class _CardCountState extends State<CardCount> {
  bool _valueVisible = true;

  void _navigate(BuildContext context) {
    if (widget.homeController.data!.accessTargeting == 3) {
      Navigator.of(context).pushNamed('listrequestsstores', arguments: {
        "codeProvider": 0,
        "userCode": 0,
      });
    } else if (widget.homeController.data!.accessTargeting == 2) {
      Navigator.of(context).pushNamed('listrequestsstorenegotiation', arguments: {
        "codeProvider": widget.homeController.data!.codCompany,
        "userCode": widget.homeController.data!.userCode,
      });
    } else {
      Navigator.of(context).pushNamed('listrequestsstores', arguments: {
        "codeProvider": widget.homeController.data!.codCompany,
        "userCode": 0,
        "visibleBuyers": true,
        "homeController": widget.homeController,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return ValueListenableBuilder(
      valueListenable: widget.homeController.stateData,
      builder: (context, value, child) {
        if (value == StateApp.loading) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Skeletonizer(
              effect: const ShimmerEffect(),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                height: 120,
                width: width,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }

        return StateManagement(
          width: width,
          listenable: widget.homeController.stateData,
          component: Container(
            // padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Material(
              // color: colorSecondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => _navigate(context),
                borderRadius: BorderRadius.circular(16),
                splashColor: colorSecondary.withValues(alpha: 0.14),
                highlightColor: colorSecondary.withValues(alpha: 0.07),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // — Header row —
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Total em pedidos",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: onSurface.withValues(alpha: 0.55),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorSecondary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 11,
                                  color: colorSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // — Value —
                      Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.15),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            ),
                            child: Align(
                              key: ValueKey(_valueVisible),
                              alignment: Alignment.centerLeft,
                              child: _valueVisible
                                  ? Text(
                                      "R\$ ${widget.homeController.data!.valueOrder!}",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: onSurface,
                                        letterSpacing: -0.5,
                                      ),
                                    )
                                  : Text(
                                      "R\$ ••••••••",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: onSurface.withValues(alpha: 0.3),
                                        letterSpacing: 2,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => setState(() => _valueVisible = !_valueVisible),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  _valueVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                  key: ValueKey(_valueVisible),
                                  size: 18,
                                  color: onSurface.withValues(alpha: 0.35),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // — Footer tags —
                      const Row(
                        children: [
                          _Tag(
                            label: "Ver detalhes",
                            color: colorSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSubtle;

  const _Tag({
    required this.label,
    required this.color,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSubtle ? color.withValues(alpha: 0.08) : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isSubtle ? color : color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
