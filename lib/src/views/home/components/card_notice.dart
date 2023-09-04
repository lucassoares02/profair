import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';

class CardNotice extends StatefulWidget {
  CardNotice({super.key, required this.homeController});

  HomeController homeController;

  @override
  State<CardNotice> createState() => _CardNoticeState();
}

class _CardNoticeState extends State<CardNotice> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/listattractions");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: appPadding),
        padding: const EdgeInsets.all(20),
        width: width,
        height: 300,
        decoration: BoxDecoration(
          // color: colorTertiary,
          color: Color(int.parse(widget.homeController.documents!.documents.first.data["color"])),
          borderRadius: BorderRadius.circular(appRadius),
          // image: const DecorationImage(
          //   fit: BoxFit.cover,
          //   opacity: 0.2,
          //   image: NetworkImage(
          //     "https://images.pexels.com/photos/1855214/pexels-photo-1855214.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          //   ),
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.asset(
            //   fit: BoxFit.contain,
            //   'assets/images/logo-client.png',
            // ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: appMargin, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(int.parse(widget.homeController.documents!.documents.first.data["colorStamp"])),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event,
                        size: 18,
                        color: colorWhite,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.homeController.documents!.documents.first.data["stamp"],
                        style: const TextStyle(
                          color: colorWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.homeController.documents!.documents.first.data["title"],
                      style: const TextStyle(
                        fontSize: 26,
                        color: colorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const AppSpacing(),
                    Text(
                      widget.homeController.documents!.documents.first.data["content"],
                      style: const TextStyle(
                        fontSize: 16,
                        color: colorWhite,
                      ),
                    ),
                  ],
                ),
                const AppSpacing(),
                Container(
                  width: double.maxFinite,
                  height: 37,
                  decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(appRadius))),
                  child: const Center(
                      child: Text(
                    "Saiba mais",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                )
              ],
            ),
          ],
        ),
        // child: FittedBox(
        //   fit: BoxFit.none,
        //   alignment: Alignment.bottomCenter,
        //   child: Image.network(
        //     'assets/images/people.png',
        //     height: 150,
        //   ),
        // ),
      ),
    );
  }
}
