import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({
    super.key,
    required this.homeController,
    this.index,
    this.filter,
  });

  final HomeController homeController;
  final Function(int?)? filter;
  final int? index;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
    widget.homeController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final organization = widget.homeController.data!.accessTargeting == 3;
    return ValueListenableBuilder(
      valueListenable: widget.homeController.stateBuyers,
      builder: (context, value, _) {
        return StateManagement(
          width: width,
          listenable: widget.homeController.stateBuyers,
          widgetLoading: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: appMargin),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  effect: const ShimmerEffect(),
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: appMargin),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(appRadius),
                    ),
                  ),
                );
              },
            ),
          ),
          component: SizedBox(
            height: organization ? 106 : 62,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: appMargin),
              itemCount: widget.homeController.buyers.length,
              itemBuilder: (context, index) {
                final buyer = widget.homeController.buyers[index];
                final isSelected = widget.index == buyer.codeBuyer;

                if (organization) {
                  return _OrgCard(
                    buyer: buyer,
                    isSelected: isSelected,
                    isLast: index == widget.homeController.buyers.length - 1,
                    onTap: () => Navigator.of(context).pushNamed(
                      'selectprovider',
                      arguments: {
                        "codeBuyer": buyer.codeBuyer,
                        "codeClient": 0,
                        "codeBranch": 0,
                      },
                    ),
                    context: context,
                  );
                }

                return _FilterChip(
                  buyer: buyer,
                  isSelected: isSelected,
                  isLast: index == widget.homeController.buyers.length - 1,
                  onTap: () => widget.filter!(buyer.codeBuyer),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OrgCard extends StatelessWidget {
  const _OrgCard({
    required this.buyer,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
    required this.context,
  });

  final dynamic buyer;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;
  final BuildContext context;

  Color get _accentColor {
    if (buyer.color != null) {
      return Color(int.parse("0XFF${buyer.color}"));
    }
    return colorSecondary;
  }

  Color get _iconBgColor {
    if (buyer.color != null) {
      return Color(int.parse("0X28${buyer.color}"));
    }
    return colorSecondary.withValues(alpha: 0.15);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 165,
        margin: EdgeInsets.only(right: isLast ? 0 : appMargin),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [colorPrimary, colorSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(appRadius),
          border: isSelected ? null : Border.all(color: Colors.grey.withValues(alpha: 0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected ? colorSecondary.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 10 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : _iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.storefront_outlined,
                    size: 16,
                    color: isSelected ? Colors.white : _accentColor,
                  ),
                ),
                if (isSelected) const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white70),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${buyer.nameBuyer}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: isSelected ? Colors.white.withValues(alpha: 0.85) : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatCurrency(buyer.total!),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.buyer,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  final dynamic buyer;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(right: isLast ? 0 : 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [colorPrimary, colorSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(appRadius),
          border: isSelected ? null : Border.all(color: Colors.grey.withValues(alpha: 0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected ? colorSecondary.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${buyer.nameBuyer}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: isSelected ? Colors.white.withValues(alpha: 0.85) : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formatCurrency(buyer.total!),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isSelected ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
