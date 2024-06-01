// ignore_for_file: file_names, avoid_print

import 'package:animate_icons/animate_icons.dart';
import 'package:bit_seven/pages/LoginPage.dart';
import 'package:bit_seven/pages/personal/collection/collectionPage.dart';
import 'package:bit_seven/pages/personal/details/detailsPage.dart';
import 'package:bit_seven/pages/personal/dynamic/dynamicPage.dart';
import 'package:bit_seven/pages/personal/message/messagePage.dart';
import 'package:bit_seven/pages/personal/personalPageController.dart';
import 'package:bit_seven/utils/overall_situation.dart';
import 'package:bit_seven/utils/service_result.dart';
import 'package:bit_seven/widget/image/ImageWidget.dart';
import 'package:bit_seven/widget/noDataWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:bit_seven/utils/netUrl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:badges/badges.dart' as badges;

class PersonalPage extends GetView<PersonalPageController> {
  final List<Widget> body = [
    const DynamicPage(),
    const CollectionPage(),
    const MessagePage()
  ];

  PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PersonalPageController());
    final size = MediaQuery.of(context).size;
    return controller.obx(
        (state) => Scaffold(
              //extendBodyBehindAppBar: true,
              body: SliderDrawer(
                sliderOpenSize: size.width - 70,
                isDraggable: false,
                isCupertino: true,
                key: controller.mykey,
                appBar: AppBar(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    leading: Obx(() => badges.Badge(
                          showBadge:
                              controller.datalistlength.isEmpty ? false : true,
                          badgeContent: Text(
                            "${controller.updating.value ? controller.datalistlength.length > 99 ? "99+" : controller.datalistlength.length : controller.datalistlength.length > 99 ? "99+" : controller.datalistlength.length}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          badgeStyle: const badges.BadgeStyle(
                              padding: EdgeInsets.all(5)),
                          position: badges.BadgePosition.topEnd(top: 5, end: 0),
                          //badges.Badge(badgeContent: Text(controller.datalistlength),child: ,)
                          child: AnimateIcons(
                            startIconColor: Colors.black,
                            endIconColor: Colors.black,
                            controller: controller.animateIconController,
                            endIcon: Icons.check,
                            startIcon: Icons.format_list_bulleted,
                            duration: const Duration(milliseconds: 400),
                            onEndIconPress: () {
                              print("点击设置开启或关闭负一屏");
                              if (controller.mykey.currentState!.isDrawerOpen) {
                                controller.mykey.currentState?.closeSlider();
                              } else {
                                controller.mykey.currentState?.openSlider();
                              }
                              return true;
                            },
                            onStartIconPress: () {
                              print("点击设置开启或关闭负一屏");
                              if (controller.mykey.currentState!.isDrawerOpen) {
                                controller.mykey.currentState?.closeSlider();
                              } else {
                                controller.mykey.currentState?.openSlider();
                              }
                              return true;
                            },
                          ),
                        )),
                    actions: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          items: [
                            ...MenuItems.firstItems.map(
                              (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                            const DropdownMenuItem<Divider>(
                                enabled: false, child: Divider()),
                            ...MenuItems.secondItems.map(
                              (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            MenuItems.onChanged(context, value as MenuItem);
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 180,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            elevation: 1,
                            offset: const Offset(1, 8),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            customHeights: [
                              ...List<double>.filled(
                                  MenuItems.firstItems.length, 48),
                              8,
                              ...List<double>.filled(
                                  MenuItems.secondItems.length, 48),
                            ],
                            padding: const EdgeInsets.only(left: 16, right: 16),
                          ),
                          customButton: SvgPicture.asset(
                            "assets/svg/external-link.svg",
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18)
                    ]),
                slider: Stack(
                  fit: StackFit.expand,
                  children: [
                    MyCachedNetworkImage("11110001000100"),
                    ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 70,
                          width: double.infinity,
                          child: Row(
                            children: [
                              TextButton.icon(
                                  onPressed: null,
                                  icon: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: MyCachedNetworkImage(
                                        controller.user.userImgUrl),
                                  ),
                                  label: Text(
                                    controller.user.userName,
                                    style: const TextStyle(fontSize: 20),
                                  )),
                              const Spacer(),
                              const Text("消息", style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 5)
                            ],
                          ),
                        ),
                        Obx(
                          () => AnimatedList(
                            shrinkWrap: true,
                            initialItemCount: controller.datalistlength.length,
                            key: controller.globalKey,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index,
                                Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(-1, -.5),
                                        end: const Offset(0, 0))
                                    .animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.decelerate)),
                                child: Dismissible(
                                  // ignore: invalid_use_of_protected_member
                                  key: Key(
                                      // ignore: invalid_use_of_protected_member
                                      "${controller.datalistlength.value[index]}_"),
                                  onDismissed: (d) {
                                    // ignore: invalid_use_of_protected_member
                                    controller.datalistlength.value
                                        .removeAt(index);
                                    controller.updating.value =
                                        !controller.updating.value;
                                    controller.globalKey.currentState!
                                        .removeItem(
                                      index,
                                      (context, animation) => FadeTransition(
                                        opacity: CurvedAnimation(
                                            parent: animation,
                                            curve: const Interval(.5, 1)),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.5),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              child: Image.asset(
                                                "assets/images/my.jpg",
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                          const SizedBox(width: 10),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth:
                                                    size.width - 70 - 110),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text("Name"),
                                                Text(
                                                  "被群成员冷暴力半年，最近没有怎么哭了，慢慢变好了……以前有多快乐，现在就有多难过。从人间烟火的日常，到红着眼睛告别，消失在彼此的世界里，很痛，也很难。今天是肯德基疯狂星期四，v我25.8，我不吃肯德基，我吃两份麦当劳12.9随心选。",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    if (controller.mykey.currentState!.isDrawerOpen) {
                      controller.mykey.currentState?.closeSlider();
                      controller.animateIconController.animateToStart();
                    }
                  },
                  child: LiquidPullToRefresh(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    backgroundColor: OverallSituation.typea[0],
                    showChildOpacityTransition: false,
                    springAnimationDurationInMilliseconds: 800,
                    onRefresh: controller.onRefresh,
                    animSpeedFactor: 2.5,
                    height: 80,
                    child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(100, 245, 245, 245),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              height: 240,
                              width: double.infinity,
                              child: Stack(children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  width: double.infinity,
                                  height: 230,
                                  //color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(children: [
                                            Text(
                                                controller.user.fwiNumber
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                            const Text("粉丝",
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                          Column(children: [
                                            Text(
                                                controller.user.vmfbsNumber
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                            const Text("关注",
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ]),
                                          Column(children: [
                                            Text(
                                                controller.user.groupNumber
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                            const Text("群组",
                                                style: TextStyle(
                                                    color: Colors.grey))
                                          ])
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  20, 158, 158, 158),
                                              blurRadius: 100,
                                              offset: Offset(0, 1))
                                        ],
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Obx(
                                      () => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await Get.to(
                                                  DetailsPage(controller.user),
                                                  transition:
                                                      Transition.rightToLeft);
                                              controller.dataload(0);
                                            },
                                            child: Hero(
                                              tag:
                                                  "${netUrl.bitnetUrl}getImg/${state!.userImgUrl}",
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                  httpHeaders:
                                                      ServiceTokenHead.headMap,
                                                  imageUrl:
                                                      "${netUrl.bitnetUrl}getImg/${state.userImgUrl}",
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Image.asset(
                                                      "assets/images/yt.jpg",
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(state.userName,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 3),
                                          Text(controller.ux.value.introduce)
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(() => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(100, 242, 242, 242),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            controller.indexNum.value = 0;
                                          },
                                          icon: SvgPicture
                                              .asset("assets/svg/home.svg",
                                                  color: controller
                                                              .indexNum.value ==
                                                          0
                                                      ? const Color
                                                              .fromARGB(
                                                          255, 29, 80, 255)
                                                      : Colors.grey),
                                          label: Text(
                                              "动态",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: controller
                                                              .indexNum.value ==
                                                          0
                                                      ? const Color.fromARGB(
                                                          255, 29, 80, 255)
                                                      : Colors.grey))),
                                      TextButton.icon(
                                          onPressed: () {
                                            controller.indexNum.value = 1;
                                          },
                                          icon: SvgPicture.asset(
                                              "assets/svg/annotation.svg",
                                              color:
                                                  controller.indexNum.value == 1
                                                      ? const Color.fromARGB(
                                                          255, 29, 80, 255)
                                                      : Colors.grey),
                                          label: Text("收藏",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: controller
                                                              .indexNum.value ==
                                                          1
                                                      ? const Color.fromARGB(
                                                          255, 29, 80, 255)
                                                      : Colors.grey))),
                                      TextButton.icon(
                                          onPressed: () {
                                            controller.indexNum.value = 2;
                                          },
                                          icon: SvgPicture.asset(
                                              "assets/svg/chat_alt.svg",
                                              color:
                                                  controller.indexNum.value == 2
                                                      ? const Color.fromARGB(
                                                          255, 29, 80, 255)
                                                      : Colors.grey),
                                          label: Text("消息",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: controller
                                                              .indexNum.value ==
                                                          2
                                                      ? const Color.fromARGB(
                                                          255, 29, 80, 255)
                                                      : Colors.grey))),
                                    ],
                                  ),
                                ),
                              )),
                          Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: body[controller.indexNum.value]))
                        ]),
                  ),
                ),
              ),
            ),
        onLoading: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
              color: OverallSituation.typea[0], size: 40),
        ),
        onEmpty: getNoDataWidget(size.width / 2));
  }
}

Widget iconNumX(int type, int number) {
  return Row(
    children: [
      SvgPicture.asset(
        type == 0 ? "assets/svg/eye.svg" : "assets/svg/chat.svg",
        fit: BoxFit.none,
        color: Colors.grey,
      ),
      const SizedBox(width: 3),
      Text(
        "$number",
        style: const TextStyle(color: Colors.grey),
      )
    ],
  );
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
    home,
    share,
    refresh,
    add,
    isaaaFun
  ];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: '主题白', icon: Icons.home);
  static const share = MenuItem(text: '主题黑', icon: Icons.share);
  static const refresh = MenuItem(text: '获取定位权限', icon: Icons.refresh);
  static const add = MenuItem(text: '消息推送', icon: Icons.add);
  static const isaaaFun = MenuItem(text: '取消推送', icon: Icons.clear);

  //static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) async {
    switch (item) {
      case MenuItems.home:
        // sets theme mode to dark
        //AdaptiveTheme.of(context).setLight();
        Get.changeTheme(ThemeData.light());

        break;
      case MenuItems.share:
        //AdaptiveTheme.of(context).setDark();
        Get.changeTheme(ThemeData.dark());
        break;
      case MenuItems.logout:
        //Do something
        //AdaptiveTheme.of(context).setSystem();
        myShowGeneralDialog(context);
        break;
      case MenuItems.refresh:
        // PersonalPageController controller = Get.find<PersonalPageController>();
        // // ignore: invalid_use_of_protected_member
        // controller.refresh();
        //权限申请
        PermissionStatus permissionStatus = await Permission.location.request();
        if (permissionStatus.isGranted) {
          print("有权限");
        } else {
          print("没有权限");
        }
        break;
      case MenuItems.add:
        PersonalPageController controller = Get.find<PersonalPageController>();
        controller.iswhile = true;
        controller.isaaaFun();
        break;
      case MenuItems.isaaaFun:
        PersonalPageController controller = Get.find<PersonalPageController>();
        controller.iswhile = false;
        break;
    }
  }
}

void myShowGeneralDialog(BuildContext context) {
  showGeneralDialog(
      barrierColor: Colors.grey.withOpacity(0.7),
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(20)),
            height: 200,
            width: 250,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 25,
                  child: Text(
                    "退出登录",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                      colors: OverallSituation.typea,
                      onPressed: () async {
                        final shared = await SharedPreferences.getInstance();
                        await deleteDatabase("user.db");
                        await Get.deleteAll();
                        Get.offAll(() => LoginPage(),
                            transition: Transition.downToUp);
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: const Text(
                        "确认",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        );
      });
}
