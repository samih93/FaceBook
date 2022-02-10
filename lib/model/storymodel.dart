class StoryModel {
  String? storyId;
  String? storyUserId;
  String? storyName;
  String? image;
  String? caption;
  String? storyDate;

  StoryModel(
      {required this.storyId,
      required this.storyUserId,
      required this.storyName,
      required this.image,
      required this.caption,
      required this.storyDate});

  StoryModel.formJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    storyUserId = json['storyUserId'];
    storyName = json['storyName'];
    image = json['image'];
    caption = json['caption'];
    storyDate = json['storyDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'storyUserId': storyUserId,
      'storyName': storyName,
      'image': image,
      'caption': caption,
      'storyDate': storyDate,
    };
  }
}
