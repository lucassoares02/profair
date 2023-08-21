import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/views/profile/profile_controller.dart';
import 'package:profair/src/views/home/state_management.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';

class Followers extends StatefulWidget {
  const Followers({
    super.key,
    required this.profileController,
  });

  final ProfileController profileController;

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  @override
  void initState() {
    super.initState();
    widget.profileController.getLikes();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: widget.profileController.stateLikes,
      builder: (context, value, _) {
        return StateManagement(
          width: width,
          listenable: widget.profileController.stateLikes,
          widgetLoading: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: SkeletonAvatar(
                      style: SkeletonAvatarStyle(height: 60, width: 60, borderRadius: BorderRadius.circular(50)),
                    ),
                  );
                }),
          ),
          component: SizedBox(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.profileController.likes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('detailsrecipe', arguments: widget.profileController.likes[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: appMargin, left: index == 0 ? appPadding : 0),
                      width: 60,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        image: DecorationImage(
                          image: NetworkImage('${widget.profileController.likes[index].image}'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(appRadius)),
                        border: Border.all(
                          color: colorPrimary,
                          width: 3.0,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
