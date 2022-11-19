class RecipeModel {
  String? label;
  String? imageUrl;
  String? source;
  String? url;

  RecipeModel([this.label, this.imageUrl, this.source, this.url]);
  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(parsedJson['label'], parsedJson['image'],
        parsedJson['source'], parsedJson['url']);
  }
}
