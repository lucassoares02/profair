import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/utils/fonts.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ListRecipe extends StatefulWidget {
  const ListRecipe({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<ListRecipe> createState() => _ListRecipeState();
}

class ListIngredients {
  String ingredient;
  bool checked;

  ListIngredients(this.ingredient, this.checked);
}

class _ListRecipeState extends State<ListRecipe> {
  List<ListIngredients> listIngredients = [];

  @override
  void initState() {
    createListIngredients();
    super.initState();
  }

  createListIngredients() {
    List<ListIngredients> listRecipe = [];
    for (var element in widget.recipe.ingredients!) {
      listRecipe.add(ListIngredients(element, false));
    }
    setState(() {
      listIngredients = listRecipe;
    });
  }

  shareRecipe() async {
    String shareText = "";
    int marked = 0;
    shareText = "*${widget.recipe.title}*\n *Ingredientes:*\n";
    for (var element in listIngredients) {
      if (element.checked) {
        if (marked == 0) {
          shareText += '\n\n*Ingredientes já marcados:*';
          marked = 1;
        }
        shareText += '\n ~_${element.ingredient}_~';
      } else {
        shareText += '\n ${element.ingredient}';
      }
    }

    shareText += '\n\nCompartilhe suas receitas prediletas com Arbian!';
    await Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lista de Compras',
                      style: textTitle,
                    ),
                    IconButton(
                        onPressed: () {
                          shareRecipe();
                        },
                        icon: const Icon(Icons.share))
                  ],
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: listIngredients.length,
                    itemBuilder: (_, index) {
                      return !listIngredients[index].checked
                          ? Row(
                              children: [
                                Checkbox(
                                    value: listIngredients[index].checked,
                                    onChanged: (value) {
                                      var teste = listIngredients[index];
                                      listIngredients.removeAt(index);
                                      listIngredients.add(teste);
                                      setState(() {
                                        listIngredients = listIngredients;
                                        listIngredients[listIngredients.length - 1].checked = !listIngredients[listIngredients.length - 1].checked;
                                      });
                                    }),
                                Flexible(
                                  child: Text(
                                    listIngredients[index].ingredient.replaceAll('- ', ''),
                                    style: TextStyle(
                                        color: listIngredients[index].checked ? Colors.grey : Colors.black,
                                        decoration: listIngredients[index].checked ? TextDecoration.lineThrough : TextDecoration.none,
                                        decorationColor: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : Container();
                    }),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: listIngredients.length,
                    itemBuilder: (_, index) {
                      return listIngredients[index].checked == true
                          ? Row(
                              children: [
                                Checkbox(
                                    value: listIngredients[index].checked,
                                    onChanged: (value) {
                                      var teste = listIngredients[index];
                                      listIngredients.removeAt(index);
                                      listIngredients.add(teste);
                                      setState(() {
                                        listIngredients = listIngredients;
                                        listIngredients[listIngredients.length - 1].checked = !listIngredients[listIngredients.length - 1].checked;
                                      });
                                    }),
                                Flexible(
                                  child: Text(
                                    listIngredients[index].ingredient.replaceAll('- ', ''),
                                    style: TextStyle(
                                        color: listIngredients[index].checked ? Colors.grey : Colors.black,
                                        decoration: listIngredients[index].checked ? TextDecoration.lineThrough : TextDecoration.none,
                                        decorationColor: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : Container();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
