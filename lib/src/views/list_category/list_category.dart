import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/home/components/last_requests.dart';
import 'package:profair/src/views/list_category/category_controller.dart';
import 'package:profair/src/views/list_category/category_repository.dart';
import 'package:profair/src/repositories/categories_icon.dart';

import 'package:flutter/material.dart';

class ListCategory extends StatefulWidget {
  const ListCategory({super.key, required this.category});

  final CategoriesIcon category;

  @override
  State<ListCategory> createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  final CategoryController categoryController = CategoryController(StateApp.start, CategoryRepository());

  @override
  void initState() {
    categoryController.categoryItems(widget.category.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // Scaffold(
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: ValueListenableBuilder(
    //         valueListenable: categoryController.stateCategoryItems,
    //         builder: (context, value, child) {
    //           return Shared(
    //             listItems: categoryController.listCategoryItems,
    //             state: categoryController.stateCategoryItems,
    //             description: widget.category.title,
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
