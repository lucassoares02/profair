import 'package:profair/generated/l10n.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';

class HeaderList extends StatefulWidget {
  HeaderList(
      {super.key,
      this.label,
      this.activeSearch = true,
      this.onSearch,
      this.icon,
      this.onSort,
      this.onOpenSearch,
      this.activePop = true,
      this.color,
      this.linearGradient,
      this.iconColor,
      this.onBackButton,
      this.aditionAction,
      this.onCloseInfo});

  String? label;
  bool? activeSearch;
  Function(String?)? onSearch;
  Function()? onSort;
  Function()? onCloseInfo;
  Function()? onBackButton;
  Function()? onOpenSearch;
  LinearGradient? linearGradient;
  Color? color;
  Color? iconColor;
  IconData? icon;
  bool activePop;
  Widget? aditionAction;

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
          decoration: BoxDecoration(color: widget.color ?? transparent),
          height: 70,
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
                                onPressed: widget.onBackButton ??
                                    () {
                                      Navigator.of(context).pop();
                                    },
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  color: widget.iconColor,
                                ),
                              ),
                            Text(
                              "${widget.label}",
                              overflow: TextOverflow.clip,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (widget.aditionAction != null) widget.aditionAction!,
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
