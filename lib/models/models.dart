import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

enum Roles {
  teacher,
  admin,
}

@JsonSerializable()
class User {
  final String? id;
  final String? fullname;
  final String? email;
  final String? password;
  @JsonKey(includeToJson: false,includeFromJson: false)
  List<Document>? documents;
  final String? workExperience;
  final String? degree;
  final String? role;
  final String? diplome;

  User(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.password,
        this.documents,
      required this.workExperience,
      required this.degree,
      required this.role,
      required this.diplome});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Document {
  String? id;
  String? name;
  String? userId;
  String? downloadUrl;
  String? date;
  String? perechen;
  String? interWorks;
  String? interConfWorks;
  String? nameBook;
  List<String>? authors;

  Document({
    this.id,
    this.name,
    this.userId,
    this.downloadUrl,
    this.date,
    this.perechen,
    this.interWorks,
    this.interConfWorks,
    this.nameBook,
    this.authors,
  });

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
