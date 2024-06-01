// ignore_for_file: file_names, unused_import

import 'package:bit_seven/model/personal_messageModel.dart';
import 'package:bit_seven/utils/netUrl.dart';
import 'package:bit_seven/widget/image/ImageWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserMessageWidget extends StatelessWidget {
  const UserMessageWidget(this.data, {super.key});
  final MessageModel data;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child:
                      MyCachedNetworkImage(data.imgurl, width: 40, height: 40),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(data.name, style: const TextStyle(fontSize: 16)),
                    SizedBox(
                      width: 230,
                      child: Text(
                        data.body,
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      data.creTime,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 13)
      ],
    );
  }
}
