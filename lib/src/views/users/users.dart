import 'package:profair/src/components/header_actions.dart';
import 'package:profair/src/controllers/users_controller.dart';
import 'package:profair/src/repositories/users_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:profair/src/utils/spacing.dart';
import 'package:profair/src/views/users/components/list.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> with SingleTickerProviderStateMixin {
  final UsersController usersController = UsersController(StateApp.start, UsersRepository());
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);

    usersController.findUsers();
    usersController.findUsersProvider();
    usersController.findUsersAssociate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          HeaderActions(
            label: "Usuários",
            onSearch: (value) {
              int currentIndex = _tabController.index;
              if (currentIndex == 0) {
                usersController.search(value);
              } else if (currentIndex == 1) {
                usersController.searchProviders(value);
              } else if (currentIndex == 2) {
                usersController.searchClients(value);
              }
            },
          ),
        ],
        bottom: TabBar(
          onTap: (value) {
            int currentIndex = _tabController.index;
            if (currentIndex == 0) {
              usersController.search("");
            } else if (currentIndex == 1) {
              usersController.searchProviders("");
            } else if (currentIndex == 2) {
              usersController.searchClients("");
            }
          },
          controller: _tabController,
          indicatorColor: colorSecondary,
          labelColor: colorSecondary,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: appPadding),
              child: Text("Organização"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: appPadding),
              child: Text("Fornecedores"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: appPadding),
              child: Text("Associados"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                valueListenable: usersController.stateUsers,
                builder: (context, value, child) {
                  return ComponentList(
                      description: "Usuários",
                      state: usersController.stateUsers,
                      listItems: usersController.users,
                      usersController: usersController);
                },
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                valueListenable: usersController.stateUsersProvider,
                builder: (context, value, child) {
                  return ComponentList(
                      description: "Usuários",
                      state: usersController.stateUsersProvider,
                      listItems: usersController.usersProvider,
                      usersController: usersController);
                },
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                valueListenable: usersController.stateUsersAssociate,
                builder: (context, value, child) {
                  return ComponentList(
                      description: "Usuários",
                      state: usersController.stateUsersAssociate,
                      listItems: usersController.usersAssociate,
                      usersController: usersController);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
