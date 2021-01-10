import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostModel with ChangeNotifier {
  String caption = " ";
  Url url = Url(
    url: '',
    mime: '',
  );
  Timestamp created = Timestamp.now();
}

class Url {
  String mime = '';
  String url = '';

  Url({this.mime, this.url});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Url(
        mime: parsedJson['mime'] ?? '', url: parsedJson['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': this.mime, 'url': this.url};
  }
}
