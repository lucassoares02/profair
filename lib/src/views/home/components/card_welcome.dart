import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CardWelcome extends StatefulWidget {
  CardWelcome({super.key, required this.homeController, required this.action});

  HomeController homeController;
  Function()? action;

  @override
  State<CardWelcome> createState() => _CardWelcomeState();
}

class _CardWelcomeState extends State<CardWelcome> {
  String? selectedItem;

  @override
  void initState() {
    selectedItem = widget.homeController.data!.nameCompany;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed('profile');
        widget.homeController.logout();
        Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
      },
      child: Container(
        margin: const EdgeInsets.only(top: appPadding),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        child: ValueListenableBuilder(
            valueListenable: widget.homeController.stateData,
            builder: (context, value, child) {
              return value == StateApp.loading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 15, width: width / 2, borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 10),
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              height: 10, width: width / 3, borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Stack(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.homeController.data!.nameUser}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              widget.homeController.moreData!.length > 1
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: DropdownButton<LoginModel>(
                                        borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
                                        underline: Container(color: Colors.transparent),
                                        isExpanded: true,
                                        icon: const Icon(Icons.keyboard_arrow_down_sharp, size: 25),
                                        hint: Text(
                                            "${widget.homeController.data!.codCompany} - ${widget.homeController.data!.nameCompany!.length > 35 ? "${widget.homeController.data!.nameCompany!.substring(0, 35)}..." : widget.homeController.data!.nameCompany!}"),
                                        items: widget.homeController.moreData!.map((e) {
                                          return DropdownMenuItem<LoginModel>(
                                            value: e,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.business_rounded,
                                                  size: 25,
                                                  color: colorGreyDark,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  e.nameCompany!.length > 35
                                                      ? "${e.nameCompany!.substring(0, 35)}..."
                                                      : e.nameCompany!,
                                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          int indexSelected = widget.homeController.moreData!.indexOf(value!);
                                          widget.homeController.indexSelected = indexSelected;
                                          setState(() {
                                            selectedItem = value.nameCompany;
                                          });
                                          widget.action!();
                                        },
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                                      child: Text(
                                        '${widget.homeController.data!.codCompany} - ${widget.homeController.data!.nameCompany}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: colorGreyDark,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}
