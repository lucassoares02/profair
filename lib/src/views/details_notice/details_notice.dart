import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/details_notice/components/details.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';
import 'package:profair/src/views/home/home_repository.dart';

class DetailsNotice extends StatefulWidget {
  DetailsNotice({super.key, required this.id, required this.codeBranch, required this.accessTargeting});

  int id;
  int codeBranch;
  int accessTargeting;

  @override
  State<DetailsNotice> createState() => _DetailsNoticeState();
}

class _DetailsNoticeState extends State<DetailsNotice> {
  HomeController homeController = HomeController(StateApp.start, HomeRepository());
  @override
  void initState() {
    super.initState();
    homeController.getNotice(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ComponentDetails(
          homeController: homeController,
          codeBranch: widget.codeBranch,
          accessTargeting: widget.accessTargeting,
        ),
      ),
    );
  }
}
