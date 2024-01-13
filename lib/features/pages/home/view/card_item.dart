import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/wave_card.dart';
import '../../../../features/pages/home/home_screen.x.dart';

class CardItem extends StatefulWidget {
  final WaveCard waveCard;

  const CardItem({
    Key? key,
    required this.waveCard,
  }) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  processing() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shadowColor: Get.theme.colorScheme.secondary,
          elevation: 5,
          child: ListTile(
              title: Text(widget.waveCard.name!),
              subtitle: Text(widget.waveCard.cardId!),
              onTap: () => {
                    HomeScreenX.to.scanAndAuthenticate(widget.waveCard).then(
                          ((result) => {
                                processing(),
                              }),
                        ),
                  }),
        ),
      ],
    );
  }
}
