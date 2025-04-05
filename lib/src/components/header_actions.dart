import 'package:flutter/material.dart';
import 'package:profair/generated/l10n.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';

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
    this.menu = false,
    this.alertClose = false,
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
  bool menu;
  bool alertClose;
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
      height: double.maxFinite,
      child: ValueListenableBuilder(
        valueListenable: visibleSearch,
        builder: (context, value, child) {
          return visibleSearch.value && widget.onSearch != null
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
                            if (controllerSearch.text.isNotEmpty) {
                              controllerSearch.text = "";
                              widget.onSearch!("");
                            } else {
                              visibleSearch.value = !visibleSearch.value;
                              controllerSearch.text = "";
                              widget.onSearch!("");
                            }
                            if (widget.onCloseInfo != null) widget.onCloseInfo!();
                          },
                          icon: const Icon(Icons.close)),
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Pesquisar",
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
                              if (widget.alertClose) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        elevation: 0.1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(appRadius),
                                        ),
                                        title: const Text('Deseja realmente sair?'),
                                        content: SizedBox(
                                            width: size.width * 1,
                                            child: const Text('Caso você volte as informações que foram digitadas serão perdidas, para que isso não aconteça finalize o pedido primeiro!')),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Confirmar"),
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                Navigator.of(context).pop();
                              }
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
                        if (widget.addIcon != null) widget.addIcon!,
                        if (widget.menu)
                          PopupMenuButton<String>(
                              color: Colors.white,
                              onSelected: (String result) {
                                // Lógica de filtro aqui
                                print('Filtro selecionado: $result');
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Filtro 1',
                                      child: Text('Ordem alfabética'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Filtro 2',
                                      child: Text('Maior valor'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Filtro 3',
                                      child: Text('Maior volume'),
                                    ),
                                  ]),
                      ],
                    )
                  ],
                );
        },
      ),
    );
  }
}
