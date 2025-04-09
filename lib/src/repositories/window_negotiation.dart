import 'package:flutter/material.dart';

class WindowNegotiationModel {
  int? id;
  int? consultantId;
  int? clientId;
  int? supplierId;
  int? storeId;
  String? startAt;
  String? endAt;

  WindowNegotiationModel({
    this.id,
    this.consultantId,
    this.clientId,
    this.supplierId,
    this.storeId,
    this.startAt,
    this.endAt,
  });

  WindowNegotiationModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      consultantId = json['consultant_id'];
      clientId = json['client_id'];
      supplierId = json['supplier_id'];
      storeId = json['store_id'];
      startAt = json['start_at'];
      endAt = json['end_at'];
    } catch (e) {
      debugPrint('$e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['consultant_id'] = consultantId;
    data['client_id'] = clientId;
    data['supplier_id'] = supplierId;
    data['store_id'] = storeId;
    data['start_at'] = startAt;
    data['end_at'] = endAt;

    return data;
  }
}
