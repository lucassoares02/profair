import 'package:fluttertoast/fluttertoast.dart';
import 'package:profair/src/repositories/order_details_repository.dart';
import 'package:profair/src/repositories/order_details_model.dart';
import 'package:profair/src/state/state_app.dart';
import 'package:flutter/material.dart';

class OrderDetailsController extends ValueNotifier<StateApp> {
  List<OrderDetailsModel> orderDetails = [];
  List<OrderDetailsModel> requests = [];
  int sortInt = 0;

  final stateSearchProducts = ValueNotifier<StateApp>(StateApp.start);

  final stateProducts = ValueNotifier<StateApp>(StateApp.start);
  final stateShare = ValueNotifier<StateApp>(StateApp.start);

  final OrderDetailsRepository _orderDetailsRepository;

  OrderDetailsController(super.value, this._orderDetailsRepository);

  Future findOrderDetails(int? codeClient, int? codeProvider, int? codeNegotiation) async {
    stateProducts.value = StateApp.loading;
    try {
      orderDetails = await _orderDetailsRepository.getOrderDetails(codeClient, codeProvider, codeNegotiation);
      requests = orderDetails;

      stateProducts.value = StateApp.success;
    } catch (e) {
      stateProducts.value = StateApp.error;
      debugPrint("Find Order Details (Order Details Controller) Error: $e");
    }
  }

  search(String? value) async {
    stateSearchProducts.value = StateApp.loading;
    try {
      if (value! == "") {
        orderDetails = requests;
      }
      orderDetails = requests.where((item) {
        return item.title!.toLowerCase().contains(value.toLowerCase());
      }).toList();

      stateSearchProducts.value = StateApp.success;
    } catch (e) {
      print("Error search Requests Stores: $e");
      stateSearchProducts.value = StateApp.error;
    }
  }

  sort() async {
    print("sort");
    stateSearchProducts.value = StateApp.loading;
    String? message = "";
    try {
      if (sortInt == 0) {
        orderDetails.sort(((a, b) => b.total!.compareTo(a.total!)));
        message = "Ordenado por valor total de vendas!";
      } else if (sortInt == 1) {
        orderDetails.sort(((a, b) => int.parse(b.amount!) - int.parse(a.amount!)));
        message = "Ordenado volume vendido!";
      } else if (sortInt == 2) {
        orderDetails.sort(((a, b) => a.title!.compareTo(b.title!)));
        message = "Ordenado por ordem alfabética!";
      }
      if (sortInt == 2) {
        sortInt = 0;
      } else {
        sortInt += 1;
      }
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);

      stateSearchProducts.value = StateApp.success;
    } catch (e) {
      print("Error Sort Stores: $e");
      stateSearchProducts.value = StateApp.error;
    }
  }
}
