import 'package:app/models/system/doc_file.dart';

class ChatContent {
  int? id;
  String? path;
  String? type;
  int? size;
  int? uploadedBy;
  String? createdAt;
  String? updatedAt;
  DocFile? doc;

  ChatContent({
    this.id,
    this.path,
    this.type,
    this.size,
    this.uploadedBy,
    this.createdAt,
    this.updatedAt,
    this.doc,
  });

  ChatContent.fromJson(json) {
    id = json['id'];
    path = json['path'];
    type = json['type'];
    size = json['size'];
    uploadedBy = json['uploaded_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['path'] = path;
    map['type'] = type;
    map['size'] = size;
    map['uploaded_by'] = uploadedBy;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
