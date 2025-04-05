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
          widgetLoading: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const Skeletonizer(
                    effect: ShimmerEffect(),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(height: 80, width: 80),
                    ),
                  );
                }),
          ),
          component: SizedBox(
            height: organization ? 110 : 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // shrinkWrap: true,
                itemCount: widget.homeController.buyers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (widget.homeController.data!.accessTargeting == 3) {
                        Navigator.of(context).pushNamed('selectprovider', arguments: {"codeBuyer": widget.homeController.buyers[index].codeBuyer, "codeClient": 0, "codeBranch": 0});
                      } else {
                        widget.filter!(widget.homeController.buyers[index].codeBuyer);
                      }
                    },
                    child: Container(
                      width: organization ? 200 : null,
                      padding: organization ? const EdgeInsets.all(appPadding) : const EdgeInsets.symmetric(horizontal: appPadding * 1.5),
                      margin: EdgeInsets.only(left: appMargin, right: index == widget.homeController.buyers.length - 1 ? appMargin : 0),
                      decoration: BoxDecoration(
                          color: widget.index == widget.homeController.buyers[index].codeBuyer ? colorSecondary : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(organization ? appRadius : appRadius * 3))),
                      child: Column(
                        mainAxisAlignment: organization ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (organization)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(
                                //   widget.homeController.buyers[index].category!,
                                //   style: const TextStyle(
                                //     fontSize: 12,
                                //   ),
                                // ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: widget.homeController.buyers[index].color != null
                                          ? Color(int.parse("0X51A${widget.homeController.buyers[index].color}"))
                                          : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(appRadius)),
                                  child: Icon(
                                    Icons.category_outlined,
                                    size: 20,
                                    color: widget.homeController.buyers[index].color != null
                                        ? Color(int.parse("0XFF${widget.homeController.buyers[index].color}"))
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          if (organization)
                            const SizedBox(
                              height: 10,
                            ),
                          Text(
                            '${widget.homeController.buyers[index].nameBuyer}',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: widget.index == widget.homeController.buyers[index].codeBuyer ? Colors.white : null),
                          ),
                          Text(
                            formatCurrency(widget.homeController.buyers[index].total!),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: widget.index == widget.homeController.buyers[index].codeBuyer ? Colors.white : null),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
