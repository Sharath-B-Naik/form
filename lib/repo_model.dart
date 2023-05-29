// enum FormAnswerType { input, radio, checkbox }

class FormModel {
  final String title;
  final String type;
  final List<String> options;
  final bool isAnswered;
  final List<String> answers;

  FormModel({
    required this.title,
    required this.type,
    this.options = const [],
    this.isAnswered = false,
    this.answers = const [],
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      title: json["title"],
      type: json["type"],
      options: List.from(json["options"]),
    );
  }

  FormModel copyWith({
    String? title,
    String? type,
    List<String>? options,
    bool? isAnswered,
    List<String>? answers,
  }) {
    return FormModel(
      title: title ?? this.title,
      type: type ?? this.type,
      isAnswered: isAnswered ?? this.isAnswered,
      options: options ?? this.options,
      answers: answers ?? this.answers,
    );
  }
}
