import 'dart:convert';

class Note {
  int? id;
  String? content;
  String? createdAt;
  bool isSelected;

  Note({this.id, this.content, this.createdAt, this.isSelected = false});

  Note.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        content = json["content"],
        createdAt = json["createdAt"],
        isSelected = json["isSelected"];

  Map<String, dynamic> toJson() => {
        'id': id,
        "content": content,
        "createdAt": createdAt,
        "isSelected": isSelected,
      };

  static String encode(List<Note> notes) => json.encode(
      notes.map<Map<String, dynamic>>((note) => note.toJson()).toList());

  static List<Note> decode(String notes) =>
      json.decode(notes).map<Note>((item) => Note.fromJson(item)).toList();
}
