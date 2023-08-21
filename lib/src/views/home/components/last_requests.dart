import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';

class LastRequests extends StatefulWidget {
  const LastRequests({super.key, required this.listItems, this.description, required this.state});

  final List<RequestsStoresModel> listItems;
  final String? description;
  final ValueListenable state;

  @override
  State<LastRequests> createState() => _LastRequestsState();
}

class _LastRequestsState extends State<LastRequests> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StateManagement(
      width: width,
      listenable: widget.state,
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
                      style: SkeletonAvatarStyle(height: 90, width: width, borderRadius: BorderRadius.circular(appRadius)),
                    ),
                  );
                }),
          ),
        ],
      ),
      component: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: appPadding, left: appPadding),
            child: Row(
              children: [
                Text(
                  widget.description ?? S.of(context).text_shared,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorGreyDark),
                )
              ],
            ),
          ),
          Column(
              children: widget.listItems.map((e) {
            return InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed('detailsrecipe', arguments: e);
              },
              child: Container(
                width: width,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                // margin: const EdgeInsets.symmetric(vertical: appMargin, horizontal: appPadding),
                decoration: const BoxDecoration(
                  color: colorLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(appRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(color: colorGreyLigth, borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: const Icon(
                        Icons.swap_vert_outlined,
                        color: colorPrimary,
                      ),
                    ),
                    const AppSpacing(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                e.razaoClient!.length < 28 ? '${e.razaoClient}' : e.razaoClient!.substring(0, 25),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'R\$ ${e.value}',
                                style: const TextStyle(
                                  color: colorGreyDark,
                                ),
                              ),
                              Text(
                                '${e.hour}',
                                style: const TextStyle(color: colorGreyDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList())
        ],
      ),
    );
  }
}
