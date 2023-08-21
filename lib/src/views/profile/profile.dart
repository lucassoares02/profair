import 'package:profair/src/views/profile/components/followers.dart';
import 'package:profair/src/views/profile/components/my_recipes.dart';
import 'package:profair/src/views/profile/profile_controller.dart';
import 'package:profair/src/views/profile/profile_repository.dart';
import 'package:profair/src/components/spacing.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/fonts.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController profileController = ProfileController(StateApp.start, ProfileRepository());

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: heigth * 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(color: colorWhite),
                  padding: const EdgeInsets.all(appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacing(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(children: [
                                const CircleAvatar(
                                  backgroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                  minRadius: 30,
                                  maxRadius: 50,
                                ),
                                Positioned(
                                  right: 8,
                                  top: 77,
                                  child: Container(
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: colorBlue),
                                    width: appRadius * 1.5,
                                    height: appRadius * 1.5,
                                    child: const Icon(
                                      Icons.check,
                                      color: colorWhite,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ]),
                              const AppSpacing(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Pedro Rafel',
                                    style: textName,
                                  ),
                                  Text(
                                    'Nutricionista',
                                    style: textInfo,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.settings_outlined)
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: appPadding * 2, horizontal: appMargin),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.phone,
                                  color: colorGrey,
                                ),
                                AppSpacing(),
                                Text(
                                  '(27) 9 9153-4123',
                                  style: textInfo,
                                )
                              ],
                            ),
                            const AppSpacing(),
                            Row(
                              children: const [
                                Icon(
                                  Icons.email,
                                  color: colorGrey,
                                ),
                                AppSpacing(),
                                Text(
                                  'pedro.rafel@hotmail.com',
                                  style: textInfo,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: appPadding),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: const [
                      //       Icon(
                      //         Icons.message,
                      //         color: colorBlue,
                      //       ),
                      //       AppSpacing(),
                      //       Icon(
                      //         Icons.favorite,
                      //         color: colorBlue,
                      //       ),
                      //       AppSpacing(),
                      //       Icon(
                      //         Icons.share,
                      //         color: colorBlue,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(color: colorWhite),
                  margin: const EdgeInsets.only(top: appMargin),
                  padding: const EdgeInsets.only(bottom: appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(appPadding),
                        child: const Text(
                          'Curtidas',
                          style: textBody,
                        ),
                      ),
                      Followers(profileController: profileController),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(color: colorWhite),
                  margin: const EdgeInsets.only(top: appMargin),
                  padding: const EdgeInsets.all(appPadding),
                  child: Row(
                    children: const [
                      Text(
                        'Minhas receitas',
                        style: textBody,
                      ),
                    ],
                  ),
                ),
                MyRecipes(
                  profileController: profileController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
