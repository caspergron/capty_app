import 'dart:io';

import 'package:flutter/services.dart';

class DocFile {
  File? file;
  bool isLarge;
  bool isValid;
  String base64;
  Uint8List? unit8List;
  int size;

  DocFile({
    this.file,
    this.isLarge = true,
    this.base64 = '',
    this.isValid = false,
    this.unit8List,
    this.size = 0,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['file'] = file;
    map['base64'] = base64;
    map['isValid'] = isValid;
    map['is_large'] = isLarge;
    map['unit8List'] = unit8List;
    map['size'] = size;
    return map;
  }
}
