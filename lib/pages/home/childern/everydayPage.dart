// ignore_for_file: file_names

import 'package:bit_seven/model/home/everydayModel.dart';
import 'package:bit_seven/widget/home/everydayWidget.dart';
import 'package:bit_seven/widget/home/homeWidget.dart';
import 'package:flutter/material.dart';

class EverydayPage extends StatefulWidget {
  const EverydayPage(this._everydayModelList, {super.key});
  final List<EverydayModel> _everydayModelList;
  @override
  State<EverydayPage> createState() => _EverydayPageState();
}

class _EverydayPageState extends State<EverydayPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BackgroundWidget(ListView(
      physics: const BouncingScrollPhysics(),
      children:
          widget._everydayModelList.map((e) => EverydayWidget(e)).toList(),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
