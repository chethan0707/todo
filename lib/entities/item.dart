import 'package:json_annotation/json_annotation.dart';
part 'item.g.dart';

@JsonSerializable()
class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  TodoItem(
      {required this.id,
      required this.title,
      required this.description,
      required this.isDone});
  factory TodoItem.fromJson(Map<String, dynamic> json) =>
      _$TodoItemFromJson(json);
}
