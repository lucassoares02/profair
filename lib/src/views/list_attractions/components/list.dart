import 'package:profair/src/components/header_list.dart';
import 'package:profair/src/components/loading_list.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/repositories/list_attractions_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class ComponentList extends StatefulWidget {
  const ComponentList({super.key, this.description, required this.listItems, required this.state});

  final List<ListAttractionsModel> listItems;
  final String? description;
  final ValueListenable state;

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
      widgetLoading: LoadingList(label: S.of(context).text_schedule),
      component: Column(
        children: [
          HeaderList(label: S.of(context).text_schedule, activeSearch: false),
          // Container(
          //   padding: const EdgeInsets.all(appPadding),
          //   decoration: const BoxDecoration(color: colorPrimary),
          //   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //     Container(
          //       padding: const EdgeInsets.all(appMargin),
          //       height: 100,
          //       width: 100,
          //       decoration: const BoxDecoration(
          //         color: colorSecondary,
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(appRadius),
          //         ),
          //       ),
          //       child: const Text("Dia 1"),
          //     ),
          //     const AppSpacing(),
          //     Container(
          //       padding: const EdgeInsets.all(appMargin),
          //       height: 100,
          //       width: 100,
          //       decoration: const BoxDecoration(
          //         color: colorSecondary,
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(appRadius),
          //         ),
          //       ),
          //       child: const Text("Dia 2"),
          //     ),
          //   ]),
          // ),
          Column(
              children: widget.listItems.asMap().entries.map((e) {
            return InkWell(
              onTap: () {
                print(int.parse(DateTime.now().hour.toString()));
                print(int.parse(widget.listItems[e.key].hour!.substring(0, 2)));
                print(int.parse(widget.listItems[e.key + (widget.listItems.length - 1 == e.key ? 0 : 1)].hour!.substring(0, 2)));
              },
              child: Container(
                width: width,
                height: 90,
                // padding: const EdgeInsets.all(appMargin),
                margin: const EdgeInsets.symmetric(horizontal: appPadding * 2),
                // decoration: const BoxDecoration(
                //   border: Border(left: BorderSide(color: colorGrey)
                //   ),
                // ),
                child: Row(
                  crossAxisAlignment: e.key == 0
                      ? CrossAxisAlignment.end
                      : (e.key == widget.listItems.length - 1)
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 2,
                      height: (e.key == 0)
                          ? 45
                          : (e.key == widget.listItems.length - 1)
                              ? 56
                              : double.maxFinite,
                      decoration: BoxDecoration(color: int.parse(e.value.hour!.substring(0, 2)) > int.parse(DateTime.now().hour.toString()) ? Colors.grey : Colors.blue),
                    ),
                    const AppSpacing(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (int.parse(widget.listItems[e.key].hour!.substring(0, 2)) < DateTime.now().hour &&
                            int.parse(widget.listItems[e.key + (widget.listItems.length - 1 == e.key ? 0 : 1)].hour!.substring(0, 2)) > DateTime.now().hour)
                          Transform.translate(
                            offset: const Offset(-27, 29),
                            child: const SpinKitPulse(color: colorSecondary, size: 22),
                          ),
                        Transform.translate(
                          offset: const Offset(-21, 13),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: int.parse(e.value.hour!.substring(0, 2)) > int.parse(DateTime.now().hour.toString()) ? Colors.grey : Colors.blue,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          e.value.title!.length < 40 ? '${e.value.title}' : e.value.title!.substring(0, 35),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${e.value.hour!} - ${e.value.content!.substring(0, 30)}",
                          style: const TextStyle(color: colorGreyDark, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
        ],
      ),
    );
  }
}

class Tuple2 {}
