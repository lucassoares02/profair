import 'package:flutter/material.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/utils/colors.dart';

class HeaderActions extends StatefulWidget {
  HeaderActions({
    super.key,
    this.label,
    this.activeSearch = true,
    this.onSearch,
    this.icon,
    this.onSort,
    this.onOpenSearch,
    this.activePop = true,
    this.color,
    this.iconColor,
    this.onCloseInfo,
    this.addIcon,
  });

  String? label;
  bool? activeSearch;
  Function(String?)? onSearch;
  Function()? onSort;
  Function()? onCloseInfo;
  Function()? onOpenSearch;
  Color? color;
  Color? iconColor;
  IconData? icon;
  bool activePop;
  Widget? addIcon;

  @override
  State<HeaderActions> createState() => _HeaderActionsState();
}

class _HeaderActionsState extends State<HeaderActions> {
  TextEditingController controllerSearch = TextEditingController();
  ValueNotifier<bool> visibleSearch = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: 70,
      child: ValueListenableBuilder(
        valueListenable: visibleSearch,
        builder: (context, value, child) {
          return visibleSearch.value
              ? Container(
                  margin: const EdgeInsets.only(top: 5, left: 3, right: 3),
                  child: TextField(
                    autofocus: true,
                    cursorColor: colorSecondary,
                    controller: controllerSearch,
                    onSubmitted: (value) {
                      if (value == "") {
                        visibleSearch.value = false;
                        if (widget.onCloseInfo != null) widget.onCloseInfo!();
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: IconButton(
                          onPressed: () {
                            visibleSearch.value = !visibleSearch.value;
                            controllerSearch.text = "";
                            widget.onSearch!("");
                            if (widget.onCloseInfo != null) widget.onCloseInfo!();
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
                        if (widget.activePop)
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                              color: widget.iconColor,
                            ),
                          ),
                        Text(
                          widget.label ?? "",
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        widget.activeSearch!
                            ? IconButton(
                                onPressed: widget.activeSearch!
                                    ? () {
                                        visibleSearch.value = !visibleSearch.value;
                                        if (widget.onCloseInfo != null) widget.onCloseInfo!();
                                        if (widget.onOpenSearch != null) widget.onOpenSearch!();
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.search,
                                  color: widget.iconColor,
                                ),
                              )
                            : const Icon(Icons.search, color: transparent),
                        if (widget.onSort != null)
                          IconButton(
                            onPressed: () {
                              widget.onSort!();
                            },
                            icon: Icon(
                              Icons.sort_outlined,
                              color: widget.iconColor,
                            ),
                          ),
                        if (widget.addIcon != null) widget.addIcon!
                      ],
                    )
                  ],
                );
        },
      ),
    );
  }
}
