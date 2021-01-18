class Moment {
  List<dynamic> urls = [];

  Moment({this.urls});

  factory Moment.fromJson(Map<String, dynamic> parsedJson) {
    return new Moment(
      urls: parsedJson['urls'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urls': this.urls,
    };
  }
}
