class ImageDetails {
  String url = "";
  String caption = "";

  ImageDetails({this.url, this.caption});

  factory ImageDetails.fromJson(Map<String, dynamic> parsedJson) {
    return new ImageDetails(
      url: parsedJson['url'],
      caption: parsedJson['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': this.url,
      'caption': this.caption,
    };
  }
}
