import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/controllers/users_controller.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/views/home/home_controller.dart';
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
    required this.homeController,
  });

  Iterable<UsersModel> listItems;
  final String? description;
  final ValueListenable state;
  final UsersController usersController;
  final HomeController homeController;

  @override
  State<ComponentList> createState() => _ComponentListState();
}

class _ComponentListState extends State<ComponentList> {
  findClient(code) async {
    await widget.homeController.findClient(code);
    LoginModel? response = await widget.homeController.findClient(code);
    int codeUser = response!.userCode ?? 0;
    if (codeUser != 0) {
      Navigator.of(context).pushNamed(
        "selectstore",
        arguments: {
          "client": response,
          "codeProvider": widget.homeController.data!.codCompany,
          "consult": widget.homeController.data!.userCode,
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Código inválido!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
    }
  }

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
      component: Padding(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: widget.usersController.stateUsers,
                builder: (context, value, child) {
                  return Column(
                      children: widget.listItems.map((e) {
                    int type = e.typeAcess!;
                    return InkWell(
                      onTap: () {
                        findClient(e.codeAcess!);
                      },
                      child: Container(
                        width: width,
                        // height: 90,
                        padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: appPadding),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),

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
      ),
    );
  }
}
