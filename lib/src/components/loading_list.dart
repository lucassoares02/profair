import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class LoadingList extends StatefulWidget {
  LoadingList({super.key, this.label, this.icon, this.loadingHeader = true, this.color, this.iconColor});

  String? label;
  IconData? icon;
  bool loadingHeader;
  Color? color;
  Color? iconColor;

  @override
  State<LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<LoadingList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (widget.loadingHeader)
          HeaderList(
            color: widget.color,
            iconColor: widget.iconColor,
            icon: widget.icon,
            label: widget.label,
            activeSearch: false,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Skeletonizer(
                effect: const ShimmerEffect(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: appMargin * 0.4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: appMargin * 1.1, vertical: appMargin * 0.9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Conteúdo
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Linha 1: negociação + badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 10,
                                    width: width / 4,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Linha 2: título
                              Container(
                                height: 13,
                                width: width / 1.6,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Linha 3: código + razão
                              Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    height: 10,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Linha 4: data
                              Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    height: 10,
                                    width: width / 4,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: appMargin * 0.5),
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Tuple2 {}
