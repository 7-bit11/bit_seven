// ignore_for_file: file_names

List<CircleModel> getCircleModelList() {
  List<CircleModel> modelList = [
    CircleModel(
        "assets/images/wallhaven-rrg6yw.jpg",
        "测试用户1",
        false,
        "https://w.wallhaven.cc/full/kx/wallhaven-kxz7g7.jpg",
        "12:59",
        "Stable Diffusion AI绘画",
        1443,
        DateTime(2023, 2, 24),
        "成都",
        848,
        2003),
    CircleModel(
        "assets/images/my.jpg",
        "测试用户2",
        true,
        "https://w.wallhaven.cc/full/d6/wallhaven-d6331o.jpg",
        "12:59",
        "Stable Diffusion AI绘画",
        1443,
        DateTime(2023, 2, 24),
        "成都",
        848,
        2003),
    CircleModel(
        "assets/images/lbl.jpg",
        "真正的ikun",
        true,
        "https://w.wallhaven.cc/full/ex/wallhaven-ex3ezo.jpg",
        "12:59",
        "Stable Diffusion AI绘画",
        1443,
        DateTime(2023, 2, 24),
        "成都",
        848,
        2003),
    CircleModel(
        "assets/images/wallhaven-85ew6j.jpg",
        "测试用户3",
        false,
        "https://w.wallhaven.cc/full/9d/wallhaven-9dzy7w.jpg",
        "12:59",
        "Stable Diffusion AI绘画",
        1443,
        DateTime(2023, 2, 24),
        "成都",
        848,
        2003)
  ];
  return modelList;
}

class CircleModel {
  late String userImg; //用户头像
  late String userName; //用户名称
  late bool attention; //是否关注
  late String videoImg; //视频封面
  late String? videoUrl; //视频路径
  late String videoTime; //视频时长
  late int lookNumber; //观看数量
  late String videoTitle; //视频标题
  late DateTime createTime; //发布日期
  late String address; //发布地址
  late int commentNumber; //评论数
  late int giveUpNumber; //点赞数
  CircleModel(
      this.userImg,
      this.userName,
      this.attention,
      this.videoImg,
      this.videoTime,
      this.videoTitle,
      this.lookNumber,
      this.createTime,
      this.address,
      this.commentNumber,
      this.giveUpNumber,
      {this.videoUrl});
}
