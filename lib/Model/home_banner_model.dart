class HomeBannerModel {
  int? id;
  String? images;

  HomeBannerModel({this.id, this.images});

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: json['id'],
      images: json['images'],
    );
  }
}