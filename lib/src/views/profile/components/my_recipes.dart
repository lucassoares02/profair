import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/profile/profile_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:flutter/material.dart';

class MyRecipes extends StatefulWidget {
  const MyRecipes({
    super.key,
    required this.profileController,
  });

  final ProfileController profileController;

  @override
  State<MyRecipes> createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  @override
  void initState() {
    super.initState();
    widget.profileController.getShared();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: widget.profileController.stateShared,
      builder: (context, value, _) {
        return StateManagement(
          width: width,
          listenable: widget.profileController.stateShared,
          component: Expanded(
            child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: appMargin / 2,
                mainAxisSpacing: appMargin / 2,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.profileController.shared.map((e) {
                  return Image.network(
                    '${e.image}',
                    fit: BoxFit.cover,
                  );
                }).toList()),
          ),
        );
      },
    );
  }
}
