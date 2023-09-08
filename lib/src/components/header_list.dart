import 'package:profair/generated/l10n.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/utils/spacing.dart';

class HeaderList extends StatefulWidget {
  HeaderList({super.key, this.label, this.activeSearch = true, this.onSearch, this.icon, this.onSort});

  String? label;
  bool? activeSearch;
  Function(String?)? onSearch;
  Function()? onSort;
  IconData? icon;

  @override
  State<HeaderList> createState() => _HeaderListState();
}

class _HeaderListState extends State<HeaderList> {
  TextEditingController controllerSearch = TextEditingController();
  ValueNotifier<bool> visibleSearch = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: colorSecondary),
          height: 65,
          child: ValueListenableBuilder(
            valueListenable: visibleSearch,
            builder: (context, value, child) {
              return visibleSearch.value
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: TextField(
                        autofocus: true,
                        cursorColor: colorSecondary,
                        controller: controllerSearch,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          suffixIcon: IconButton(
                              onPressed: () {
                                visibleSearch.value = !visibleSearch.value;
                                controllerSearch.text = "";
                                widget.onSearch!("");
                              },
                              icon: const Icon(Icons.close)),
                          prefixIcon: const Icon(Icons.search),
                          hintText: S.of(context).text_search,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                          ),
                        ),
                        onChanged: (value) {
                          widget.onSearch!(value);
                        },
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: colorWhite,
                                size: 20,
                              ),
                            ),
                            Text(
                              "${widget.label}",
                              style: const TextStyle(fontSize: 20, color: colorWhite, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: widget.activeSearch!
                                  ? () {
                                      visibleSearch.value = !visibleSearch.value;
                                    }
                                  : null,
                              icon: Icon(
                                color: widget.activeSearch! ? colorWhite : transparent,
                                Icons.search,
                              ),
                            ),
                            if (widget.onSort != null)
                              IconButton(
                                onPressed: () {
                                  widget.onSort!();
                                },
                                icon: const Icon(
                                  color: colorWhite,
                                  Icons.sort_outlined,
                                ),
                              ),
                          ],
                        )
                      ],
                    );
            },
          ),
        ),
        // Container(
        //   width: width,
        //   decoration: const BoxDecoration(
        //     color: colorSecondary,
        //     border: Border(
        //       top: BorderSide(color: colorSecondary),
        //     ),
        //   ),
        //   padding: const EdgeInsets.all(appPadding),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Icon(widget.icon, size: 24, color: colorWhite),
        //       const SizedBox(width: appMargin),
        //       Text(
        //         "${widget.label}",
        //         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorWhite),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class Tuple2 {}
