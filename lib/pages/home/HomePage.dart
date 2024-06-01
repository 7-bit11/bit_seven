// ignore_for_file: file_names

import 'package:bit_seven/model/home/atlasModel.dart';
import 'package:bit_seven/model/home/everydayModel.dart';
import 'package:bit_seven/pages/bit/bithomePage.dart';
import 'package:bit_seven/pages/home/childern/NewsPage.dart';
import 'package:bit_seven/pages/home/childern/atlasPage.dart';
import 'package:bit_seven/pages/home/childern/everydayPage.dart';
import 'package:bit_seven/widget/indicator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late List<Tab> myTabs;
  late List<Widget> myPages;
  late TabController _tabController;
  late List<EverydayModel> _everydayModelList;
  late List<AtlasModel> _atlasModelList;
  @override
  void initState() {
    super.initState();

    myTabs = const [
      Tab(child: Text("综合", style: TextStyle(fontFamily: "alimm"))),
      Tab(child: Text("推荐图集", style: TextStyle(fontFamily: "alimm"))),
      Tab(child: Text("经典老番", style: TextStyle(fontFamily: "alimm"))),
      Tab(child: Text("新闻", style: TextStyle(fontFamily: "alimm")))
    ];
    _everydayModelList = [
      EverydayModel("assets/images/wallhaven-85ew6j.jpg", "XX电影正式上映", 128, 62,
          "13:15", 66),
      EverydayModel("assets/images/wallhaven-zyz25o.jpg", "summerTime", 128, 62,
          "13:15", 66),
      EverydayModel("assets/images/wallhaven-jxw7ym.jpg", "草莓应该怎么恰", 128, 62,
          "13:15", 66),
      EverydayModel(
          "assets/images/wallhaven-2yzl89.jpg", "超跑测评", 128, 62, "13:15", 66),
    ];
    _atlasModelList = [
      AtlasModel("assets/images/wallhaven-zyzj1w.jpg", "电脑"),
      AtlasModel("assets/images/wallhaven-d636xm.png", "猫猫"),
      AtlasModel("assets/images/wallhaven-zyz25o.jpg", "日落"),
      AtlasModel("assets/images/wallhaven-2yzx89 (1).jpg", "草原"),
      AtlasModel("assets/images/wallhaven-85ew6j.jpg", "猫猫虫"),
      AtlasModel("assets/images/yt.jpg", "九转大肠"),
      AtlasModel("assets/images/wallhaven-rrg6yw.jpg", "丽"),
    ];
    myPages = [
      const BitHomePage(),
      AtlasPage(_atlasModelList),
      EverydayPage(_everydayModelList),
      const NewsPage()
    ];
    _tabController = TabController(length: myPages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          shadowColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          toolbarHeight: 0,
          bottom: tabBarStyleTypea(myTabs, _tabController),
        ),
        body: TabBarView(
          controller: _tabController,
          children: myPages,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

TabBar tabBarStyleTypea(List<Tab> myTabs, TabController tabController) {
  return TabBar(
    indicator: const Indicator(color: Color.fromARGB(255, 29, 80, 255)),
    tabs: myTabs,
    isScrollable: true,
    indicatorColor: const Color.fromARGB(255, 29, 80, 255),
    indicatorSize: TabBarIndicatorSize.label,
    physics: const BouncingScrollPhysics(),
    labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    controller: tabController,
  );
}
