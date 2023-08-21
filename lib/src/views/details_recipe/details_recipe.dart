import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/details_recipe/components/card_info.dart';
import 'package:profair/src/repositories/recipe_model.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/fonts.dart';
import 'package:profair/src/views/home/components/notices.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';
import 'package:flutter/material.dart';

class DetailsRecipe extends StatefulWidget {
  const DetailsRecipe({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<DetailsRecipe> createState() => _DetailsRecipeState();
}

class _DetailsRecipeState extends State<DetailsRecipe> {
  final HomeController homeController = HomeController(StateApp.start, HomeRepository());

  @override
  void initState() {
    // homeController.getSuggestions(widget.recipe.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(widget.recipe.image ?? ''), fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(appPadding),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    children: [
                      Text(
                        '${widget.recipe.title}',
                        style: textTitle,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.star,
                            color: colorTertiary,
                          ),
                          Text(
                            ' 4,9',
                            style: TextStyle(color: colorGreyDark),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              CardInfo(
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [const Icon(Icons.timer, size: 30), Text('${widget.recipe.time}')]),
                    Column(children: [const Icon(Icons.rice_bowl_outlined, size: 30), Text('${widget.recipe.portion}')]),
                    Column(children: [const Icon(Icons.cookie, size: 30), Text('${widget.recipe.category}')]),
                  ],
                ),
              ),
              const AppSpacing(),
              CardInfo(
                description: 'Ingredientes',
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: appMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.recipe.ingredients!
                            .map(
                              (e) => Container(
                                width: width,
                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: colorGrey))),
                                margin: const EdgeInsets.symmetric(vertical: appMargin / 1.5),
                                child: Text(e, style: textBody),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/listrecipe', arguments: widget.recipe);
                            },
                            icon: const Icon(
                              Icons.edit_document,
                              color: colorBlue,
                              size: 25,
                            )),
                      ],
                    )
                  ],
                ),
              ),
              const AppSpacing(),
              CardInfo(
                description: 'Preparo',
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.recipe.preparation!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: appPadding),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(appRadius)),
                      margin: const EdgeInsets.symmetric(vertical: appMargin / 1.5),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}º',
                            style: textTitleCard,
                          ),
                          const AppSpacing(),
                          Flexible(
                            child: Text(
                              widget.recipe.preparation![index].replaceAll('-', ''),
                              style: textBody,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const AppSpacing(),
              // CardInfo(
              //   clean: true,
              //   description: 'Sugeridos',
              //   body: ValueListenableBuilder(
              //     valueListenable: homeController.stateSuggestions,
              //     builder: (context, value, child) {
              //       return Notices(
              //         state: homeController.stateSuggestions,
              //         listItems: homeController.suggestions,
              //         cardHeigth: 150,
              //         cardWidth: 250,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
