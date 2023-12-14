import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/guitar_songs/Frame_for_news/DetalNewPage.dart';

class FrameCard extends StatelessWidget {
  const FrameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Get.to(DetalNewPage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/my-songbook-5fb9f.appspot.com/o/Slide%2016_9%20-%201.png?alt=media&token=4112f6f6-8156-4293-b731-17f36945c73b",));
          },
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: SizedBox(
                  child: CachedNetworkImage(
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/my-songbook-5fb9f.appspot.com/o/Slide%2016_9%20-%201.png?alt=media&token=4112f6f6-8156-4293-b731-17f36945c73b'),
                ),
              ),
              Positioned(
                  right: 10,
                  bottom: 10,
                  child: Text(
                    "Нажмите для просмотра",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
