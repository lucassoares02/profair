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
          component: SizedBox(
            height: 110,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.homeController.buyers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('selectprovider', arguments: {
                        "codeBuyer": widget.homeController.buyers[index].codeBuyer,
                        "codeClient": 0,
                        "codeBranch": 0
                      });
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(appPadding),
                      margin: EdgeInsets.only(
                          left: appMargin, right: index == widget.homeController.buyers.length - 1 ? appMargin : 0),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(appRadius))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.homeController.buyers[index].category!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: widget.homeController.buyers[index].color != null
                                        ? Color(int.parse("0X51A${widget.homeController.buyers[index].color}"))
                                        : Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(appRadius)),
                                child: Icon(
                                  Icons.category_outlined,
                                  size: 20,
                                  color: widget.homeController.buyers[index].color != null
                                      ? Color(int.parse("0XFF${widget.homeController.buyers[index].color}"))
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.homeController.buyers[index].nameBuyer}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            formatCurrency(widget.homeController.buyers[index].total!),
                            style: const TextStyle(
                              fontSize: 12,
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
