import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/format_currency.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

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
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: SkeletonAvatar(
                      style: SkeletonAvatarStyle(height: 80, width: 80, borderRadius: BorderRadius.circular(appRadius)),
                    ),
                  );
                }),
          ),
          component: Container(
            height: 110,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.homeController.buyers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('selectprovider', arguments: {"codeBuyer": widget.homeController.buyers[index].codeBuyer, "codeClient": 0, "codeBranch": 0});
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(appPadding),
                      margin: EdgeInsets.only(left: appMargin, right: index == widget.homeController.buyers.length - 1 ? appMargin : 0),
                      decoration: const BoxDecoration(color: colorSecondary, borderRadius: BorderRadius.all(Radius.circular(appRadius))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.handshake_outlined,
                            color: colorWhite,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            formatCurrency(widget.homeController.buyers[index].total!),
                            style: const TextStyle(
                              color: colorWhite,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.homeController.buyers[index].nameBuyer}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: colorWhite,
                            ),
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
