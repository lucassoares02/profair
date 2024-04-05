import 'package:profair/src/controllers/users_controller.dart';
import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ComponentList extends StatefulWidget {
  ComponentList({
    super.key,
    this.description,
    required this.listItems,
    required this.state,
    required this.usersController,
  });

  Iterable<UsersModel> listItems;
  final String? description;
  final ValueListenable state;
  final UsersController usersController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
      widgetLoading: LoadingList(
        icon: Icons.groups_2_sharp,
        label: widget.description,
        loadingHeader: false,
      ),
      component: Column(
        children: [
          // HeaderList(
          //   icon: Icons.groups_2_sharp,
          //   onSearch: (String? value) {
          //     widget.usersController.search(value);
          //   },
          //   label: widget.description,
          // ),
          ValueListenableBuilder(
              valueListenable: widget.usersController.stateUsers,
              builder: (context, value, child) {
                return Column(
                    children: widget.listItems.map((e) {
                  int type = e.typeAcess!;
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                              content: SizedBox(
                            width: width,
                            height: 300,
                            child: Center(
                              child: RepaintBoundary(
                                key: GlobalKey(),
                                child: QrImageView(
                                  data: e.codeAcess!,
                                  version: QrVersions.auto,
                                  size: 250.0,
                                ),
                              ),
                            ),
                          ));
                        }),
                      );
                    },
                    child: Container(
                      width: width,
                      // height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                      decoration:
                          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // const Icon(Icons.paid, color: colorPrimary, size: 20),
                                  Text(
                                    e.codeUser.toString(),
                                    style: const TextStyle(color: colorGreyDark),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: type == 1
                                          ? colorGreen
                                          : type == 2
                                              ? colorTertiary
                                              : colorPrimary,
                                      borderRadius: BorderRadius.circular(appRadius),
                                    ),
                                    child: Text(
                                      (type == 1)
                                          ? "Fornecedor"
                                          : (type == 2)
                                              ? "Associado"
                                              : "Organização",
                                      style: const TextStyle(color: colorWhite),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                e.nameUser!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.nameProvider.toString(),
                                    style: const TextStyle(color: colorGreyDark),
                                  ),
                                  Text(
                                    e.codeAcess.toString(),
                                    style: const TextStyle(color: colorGreyDark),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                      // ),
                    ),
                  );
                }).toList());
              })
        ],
      ),
    );
  }
}
