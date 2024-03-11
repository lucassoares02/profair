import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';

class ListProviders extends StatefulWidget {
  const ListProviders({
    super.key,
    this.description,
    required this.homeController,
  });

  final String? description;
  final HomeController homeController;

  @override
  State<ListProviders> createState() => _ListProvidersState();
}

class _ListProvidersState extends State<ListProviders> {
  @override
  void initState() {
    super.initState();
    widget.homeController.findTopProviders();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
        valueListenable: widget.homeController.stateTopProvider,
        builder: (context, state, child) {
          return StateManagement(
            width: width,
            listenable: widget.homeController.stateTopProvider,
            widgetLoading: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(appPadding),
                    child: SkeletonLine(
                      style: SkeletonLineStyle(width: width / 2),
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: appMargin, horizontal: appMargin),
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                height: 90, width: width, borderRadius: BorderRadius.circular(appRadius)),
                          ),
                        );
                      }),
                ),
              ],
            ),
            component: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: appMargin, left: appPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.description ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "selectprovider",
                              arguments: {
                                "codeClient": widget.homeController.data!.userCode,
                                "codeBuyer": 0,
                                "codeBranch": widget.homeController.data!.codCompany,
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_forward))
                    ],
                  ),
                ),
                widget.homeController.topProviders.isEmpty
                    ? Container(
                        padding: const EdgeInsets.only(left: appPadding),
                        child: const Row(
                          children: [
                            Text(
                              "Não possui Fornecedores!",
                              style: TextStyle(color: colorGreyDark, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 210,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.homeController.topProviders.length,
                            itemBuilder: ((context, index) {
                              final lastItem = widget.homeController.topProviders.length - 1 == index;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    "detailsprovider",
                                    arguments: {
                                      "codeProvider": widget.homeController.topProviders[index].codeProvider,
                                      "imageProvider": widget.homeController.topProviders[index].image,
                                      "nameProvider": widget.homeController.topProviders[index].nameProvider,
                                      "codeBranch": widget.homeController.data!.codCompany,
                                      "color": widget.homeController.topProviders[index].color
                                    },
                                  );
                                },
                                child: Container(
                                  width: 250,
                                  margin: EdgeInsets.only(left: appMargin, right: lastItem ? appMargin : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(appRadius),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: widget.homeController.topProviders[index].color != null
                                                      ? Color(
                                                          int.parse(widget.homeController.topProviders[index].color!))
                                                      : colorPrimary,
                                                  borderRadius: BorderRadius.circular(appRadius)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  widget.homeController.topProviders[index].image != null
                                                      ? Image.network(
                                                          widget.homeController.topProviders[index].image!,
                                                          width: 100,
                                                          height: 100,
                                                        )
                                                      : Container(
                                                          width: 100,
                                                          height: 100,
                                                          child: Icon(
                                                            Icons.image_not_supported_outlined,
                                                            color: colorWhite.withOpacity(0.3),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(appMargin),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${widget.homeController.topProviders[index].nameProvider}",
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  const Text(
                                                    "Conheça um pouco mais nossos produtos!",
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      color: colorGreyDark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                      )
                // : Row(
                //     children: widget.listItems.map((e) {
                //     return InkWell(
                //       onTap: () {
                //         // Navigator.of(context).pushNamed('detailsrecipe', arguments: e);
                //       },
                //       child: Container(
                //         width: 250,
                //         height: 150,
                //         padding: const EdgeInsets.symmetric(horizontal: appMargin),
                //         margin: const EdgeInsets.symmetric(vertical: appMargin / 2),
                //         decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(appRadius)),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Row(
                //                     children: [
                //                       Text(
                //                         "Teste",
                //                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                //                       ),
                //                     ],
                //                   ),
                //                   const SizedBox(height: 5),
                //                   Row(
                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       Text(
                //                         formatCurrency(e.totalValue!),
                //                         style: const TextStyle(
                //                             // color: colorGreyDark,
                //                             ),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   }).toList())
              ],
            ),
          );
        });
  }
}
