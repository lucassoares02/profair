import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/repositories/users_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class UsersController extends ValueNotifier<StateApp> {
  List<UsersModel> users = [];
  List<UsersModel> usersBackup = [];
  List<UsersModel> usersProvider = [];
  List<UsersModel> usersProviderBackup = [];
  List<UsersModel> usersAssociate = [];
  List<UsersModel> usersAssociateBackup = [];

  final stateUsers = ValueNotifier<StateApp>(StateApp.start);
  final stateUsersProvider = ValueNotifier<StateApp>(StateApp.start);
  final stateUsersAssociate = ValueNotifier<StateApp>(StateApp.start);

  final UsersRepository userRepository;

  UsersController(super.value, this.userRepository);

  Future findUsers() async {
    stateUsers.value = StateApp.loading;
    try {
      users = await userRepository.getUsers();
      usersBackup = users;
      stateUsers.value = StateApp.success;
    } catch (e) {
      debugPrint("Find Users (Users Controller) Error: $e");
      stateUsers.value = StateApp.error;
    }
  }

  Future findUsersProvider() async {
    stateUsersProvider.value = StateApp.loading;
    try {
      usersProvider = await userRepository.getUsersProvider();
      usersProviderBackup = usersProvider;
      stateUsersProvider.value = StateApp.success;
    } catch (e) {
      debugPrint("Find Users Provider (Users Controller) Error: $e");
      stateUsersProvider.value = StateApp.error;
    }
  }

  Future findUsersAssociate() async {
    stateUsersAssociate.value = StateApp.loading;
    try {
      usersAssociate = await userRepository.getUsersAssociate();
      usersAssociateBackup = usersAssociate;
      stateUsersAssociate.value = StateApp.success;
    } catch (e) {
      debugPrint("Find Users Associate (Users Controller) Error: $e");
      stateUsersAssociate.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateUsers.value = StateApp.loading;
    try {
      if (value! == "") {
        users = usersBackup;
      }
      users = usersBackup.where((item) {
        return item.nameUser!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateUsers.value = StateApp.success;
    } catch (e) {
      debugPrint("Search (Users Controller) Error: $e");
      stateUsers.value = StateApp.error;
    }
  }

  searchProviders(String? value) async {
    stateUsersProvider.value = StateApp.loading;
    try {
      if (value! == "") {
        usersProvider = usersProviderBackup;
      }
      usersProvider = usersProviderBackup.where((item) {
        return item.nameUser!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateUsersProvider.value = StateApp.success;
    } catch (e) {
      debugPrint("Search Providers (Users Controller) Error: $e");
      stateUsersProvider.value = StateApp.error;
    }
  }

  searchClients(String? value) async {
    stateUsersAssociate.value = StateApp.loading;
    try {
      if (value! == "") {
        usersAssociate = usersAssociateBackup;
      }
      usersAssociate = usersAssociateBackup.where((item) {
        return item.nameUser!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateUsersAssociate.value = StateApp.success;
    } catch (e) {
      debugPrint("Search Clients (Users Controller) Error: $e");
      stateUsersAssociate.value = StateApp.error;
    }
  }
}
