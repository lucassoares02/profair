import 'package:profair/src/views/details_attraction/components/details.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';

class DetailsAttractions extends StatefulWidget {
  DetailsAttractions({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.hour,
    required this.image,
    required this.homeController,
  });

  int id;
  String title;
  String content;
  String hour;
  String image;
  HomeController homeController;

  @override
  State<DetailsAttractions> createState() => _DetailsAttractionsState();
}

class _DetailsAttractionsState extends State<DetailsAttractions> {
  @override
  void initState() {
    super.initState();
    widget.homeController.findNotification(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ComponentDetails(
            homeController: widget.homeController,
            title: widget.title,
            content: widget.content,
            hour: widget.hour,
            image: widget.image,
          ),
        ),
      ),
    );
  }
}
