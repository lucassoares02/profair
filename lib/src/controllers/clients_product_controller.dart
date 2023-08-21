import 'package:profair/src/models/clients_product_model.dart';
import 'package:profair/src/repositories/clients_product_repository.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class ClientsProductController extends ValueNotifier<StateApp> {
  Iterable<ClientsProductModel> clientsProductList = [];
  Iterable<ClientsProductModel> clientsProduct = [];

  final stateSearchClientProduct = ValueNotifier<StateApp>(StateApp.start);

  final stateClientProduct = ValueNotifier<StateApp>(StateApp.start);

  final ClientsProductRepository _clientsProductRepository;

  ClientsProductController(super.value, this._clientsProductRepository);

  Future findClientProduct(int? codeProduct) async {
    stateClientProduct.value = StateApp.loading;
    try {
      clientsProductList = await _clientsProductRepository.getClientProduct(codeProduct!);
      clientsProduct = clientsProductList;

      stateClientProduct.value = StateApp.success;
    } catch (e) {
      stateClientProduct.value = StateApp.error;
    }
  }

  search(String? value) async {
    stateSearchClientProduct.value = StateApp.loading;
    try {
      if (value! == "") {
        clientsProductList = clientsProduct;
      }
      clientsProductList = clientsProduct.where((item) {
        return item.nameClient!.toLowerCase().contains(value.toLowerCase());
      });

      stateSearchClientProduct.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchClientProduct.value = StateApp.error;
    }
  }
}
