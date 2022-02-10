class StoryModel {
  String? storyId;
  String? image;
  String? caption;
  String? storyDate;

  StoryModel(
      {required this.storyId,
      required this.image,
      required this.caption,
      required this.storyDate});

  StoryModel.formJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    image = json['image'];
    caption = json['caption'];
    storyDate = json['storyDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'image': image,
      'caption': caption,
      'storyDate': storyDate,
    };
  }
}
