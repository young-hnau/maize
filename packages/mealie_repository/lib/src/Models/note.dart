part of '../mealie_repository.dart';

class Note extends Equatable {
  Note({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  static Note fromData({required Map<String, dynamic> data}) {
    return Note(title: data['title'], text: data['text']);
  }

  Note copyWith({
    String? title,
    String? text,
  }) {
    return Note(title: title ?? this.title, text: text ?? this.text);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = this.title;
    json['text'] = this.text;
    return json;
  }

  @override
  List<Object?> get props => [title, text];
}
