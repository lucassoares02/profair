import 'package:profair/src/views/details_attraction/components/details.dart';
import 'package:flutter/material.dart';

class DetailsAttractions extends StatefulWidget {
  DetailsAttractions({super.key, required this.title, required this.content, required this.hour, required this.image});

  String title;
  String content;
  String hour;
  String image;

  @override
  State<DetailsAttractions> createState() => _DetailsAttractionsState();
}

class _DetailsAttractionsState extends State<DetailsAttractions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ComponentDetails(
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
