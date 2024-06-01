// ignore_for_file: file_names

class NewsModel {
  NewsModel(this.title, this.time, this.eyeNumber, this.comment, {this.imgUrl});
  late String? imgUrl;
  late String title;
  late String time;
  late int eyeNumber;
  late int comment;
}
