import 'package:profair/src/components/header_actions.dart';
import 'package:profair/src/controllers/users_controller.dart';
import 'package:profair/src/repositories/users_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:profair/src/views/customers/components/list.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/views/home/home_controller.dart';

class Customers extends StatefulWidget {
  const Customers({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> with SingleTickerProviderStateMixin {
  final UsersController usersController = UsersController(StateApp.start, UsersRepository());

  @override
  void initState() {
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
            label: "Selecione o cliente",
            onSearch: (value) {
              usersController.searchClientsAndProvider(value);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: usersController.stateUsersAssociate,
                builder: (context, value, child) {
                  return ComponentList(
                    description: "Associados",
                    state: usersController.stateUsersAssociate,
                    listItems: usersController.usersAssociate,
                    homeController: widget.homeController,
                    usersController: usersController,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
