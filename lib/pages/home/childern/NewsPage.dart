// ignore_for_file: file_names

import 'package:bit_seven/model/home/newsModel.dart';
import 'package:bit_seven/widget/home/homeWidget.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin {
  late List<NewsModel> data;

  final globalKey = GlobalKey<AnimatedListState>();
  final List<String> buttomItem = [
    "assets/images/wallhaven-jxw7ym.jpg",
    "assets/images/wallhaven-gp5gpl.jpg",
    "assets/images/wallhaven-zyzj1w.jpg"
  ];
  late String dUrl = "assets/images/wallhaven-d636xm.png";
  late NewsModel item = NewsModel("", "", 0, 0, imgUrl: dUrl);
  late bool isa = true;
  @override
  void initState() {
    super.initState();
    data = [item];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BackgroundWidget(ListView(
      children: [
        const SizedBox(height: 10),
        isa
            ? Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  getLabelWidget("assets/svg/star.svg", "收藏"),
                  const SizedBox(width: 10),
                  getLabelWidget("assets/svg/star.svg", "本季新番"),
                  const SizedBox(width: 10),
                  getLabelWidget("assets/svg/star.svg", "每日更新"),
                  GestureDetector(
                    child: SvgPicture.asset("assets/svg/x.svg"),
                    onTap: () {
                      setState(() {
                        isa = false;
                      });
                    },
                  )
                ],
              )
            : Container(),
        getItemListWidget1(data, globalKey),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              getButtonWidget(() {
                setState(() {
                  data.add(item);
                  globalKey.currentState!.insertItem(data.length - 1);
                });
              }, "添加"),
              getButtonWidget(() {
                setState(() {
                  if (data.length > 1) {
                    globalKey.currentState!.removeItem(
                      data.length - 1,
                      (context, animation) {
                        // 删除过程执行的是反向动画，animation.value 会从1变为0
                        data.removeAt(data.length - 1);
                        // 删除动画是一个合成动画：渐隐 + 缩小列表项告诉
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            //让透明度变化的更快一些
                            curve: const Interval(0, 1.0),
                          ),
                          // 不断缩小列表项的高度
                          child: SizeTransition(
                            sizeFactor: animation,
                            axisAlignment: 0.0,
                            child: getItemWidget(data[data.length - 1]),
                          ),
                        );
                      },
                      duration:
                          const Duration(milliseconds: 200), // 动画时间为 200 ms
                    );
                  }
                });
              }, "删除")
            ],
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: buttomItem
                  .map((e) => GestureDetector(
                        onTap: () {
                          // setState(() {
                          //   item.imgUrl = e;
                          // });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(
                            e,
                            fit: BoxFit.cover,
                            width: 200,
                          ),
                        ),
                      ))
                  .toList(),
            ))
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget getItemListWidget(List<NewsModel> a) {
  return Column(
    // shrinkWrap: true,
    // physics: NeverScrollableScrollPhysics(),
    children: a.map((e) => getItemWidget(e)).toList(),
  );
}

//globalKey.currentState!.insertItem(data.length - 1);
Widget getItemListWidget1(
    List<NewsModel> a, GlobalKey<AnimatedListState> globalKey) {
  return AnimatedList(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    key: globalKey,
    initialItemCount: a.length,
    itemBuilder: (context, index, animation) {
      return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
                  .animate(animation),
          child: FadeTransition(
              opacity: animation,
              child: SizeTransition(
                axis: Axis.vertical,
                sizeFactor: animation,
                child: getItemWidget(a[index]),
              )));
    },
  );
}

Widget getItemWidget(NewsModel data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Container(
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(10, 158, 158, 158),
                blurRadius: 100,
                offset: Offset(0, 1))
          ],
          color: Color.fromARGB(255, 250, 250, 250),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              data.imgUrl.toString(),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "XXXXXX",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("5分钟前", style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    Row(children: [
                      SvgPicture.asset(
                        "assets/svg/eye.svg",
                        color: Colors.grey,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5),
                      const Text("32", style: TextStyle(color: Colors.grey))
                    ]),
                    const SizedBox(width: 10),
                    Row(children: [
                      SvgPicture.asset(
                        "assets/svg/chat.svg",
                        color: Colors.grey,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5),
                      const Text("234", style: TextStyle(color: Colors.grey))
                    ])
                  ],
                )
              ],
            )
          ])
        ],
      ),
    ),
  );
}

Widget getLabelWidget(String svgurl, String labeName) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgurl,
              color: const Color.fromARGB(255, 29, 80, 255)),
          Text(labeName, style: const TextStyle(fontSize: 16))
        ],
      ));
}

Widget getButtonWidget(Function() onClick, String buttonName) {
  final List<Color> typeb = [
    const Color.fromARGB(34, 177, 174, 174),
    const Color.fromARGB(48, 209, 208, 208)
  ];
  return SizedBox(
      width: 150,
      height: 30,
      child: GradientButton(
          disabledColor: Colors.red,
          colors: typeb,
          onPressed: onClick,
          borderRadius: const BorderRadius.all(Radius.circular(113)),
          child: Text(
            buttonName,
            style: const TextStyle(
                fontSize: 17, color: Color.fromARGB(255, 94, 94, 94)),
          )));
}
