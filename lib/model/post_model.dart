class PostModel {
  String? name;
  String? image;
  String? uId;
  String? postdate;
  String? text;
  String? postImage;
  String? postId;
  List<String>? likes = [];
  int nbOfLikes = 0;
  bool? isEmailVerified;

  PostModel({
    this.name,
    this.image,
    this.uId,
    this.postdate,
    this.text,
    this.postImage,
    this.postId,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    uId = json['uId'];
    postdate = json['postdate'];
    text = json['text'];
    postImage = json['postImage'];
    postId = json['postId'];
    nbOfLikes = json['nbOfLikes'] as int;
    if (json['likes'] != null)
      json['likes'].forEach((element) {
        likes!.add(element);
      });
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'uId': uId,
      'postdate': postdate,
      'text': text,
      'postImage': postImage,
      'postId': postId,
      'nbOfLikes': nbOfLikes,
      'likes': likes
    };
  }
}
