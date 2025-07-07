import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/details_attraction/components/details.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';

class DetailsAttractions extends StatefulWidget {
  DetailsAttractions({super.key, required this.id});

  int id;

  @override
  State<DetailsAttractions> createState() => _DetailsAttractionsState();
}

class _DetailsAttractionsState extends State<DetailsAttractions> {
  HomeController homeController = HomeController(StateApp.start, HomeRepository());
  @override
  void initState() {
    super.initState();
    homeController.findNotification(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ComponentDetails(
            homeController: homeController,
          ),
        ),
      ),
    );
  }
}
