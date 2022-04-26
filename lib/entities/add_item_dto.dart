import 'package:todo/entities/item.dart';

class AddItemDTO {
  TodoItem? item;
  String? email;

  AddItemDTO({this.item, this.email});

  AddItemDTO.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? TodoItem.fromJson(json['item']) : null;
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (item != null) {
      data['item'] = item!.toJson();
    }
    data['email'] = email;
    return data;
  }
}
