import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/news.dart';
import '../../components/remote_config.dart';
import 'detalNews.dart';

class CardNews extends StatefulWidget {
  CardNews({super.key});

  @override
  State<CardNews> createState() => _CardNewsState();
}

int activePage = 0;

class _CardNewsState extends State<CardNews> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder(
            future: getNews(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  JSONValue().length == 0
                      ? SizedBox()
                      : CarouselSlider.builder(
                          carouselController: _controller,
                          itemCount: JSONValue().length,
                          options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              autoPlay: JSONValue().length > 1 ? true : false,
                              autoPlayInterval: Duration(seconds: 15),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activePage = index;
                                });
                              }),
                          itemBuilder: (context, index, realIndex) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: JSONValue()[index].imageUrl != ''
                                    ? GestureDetector(
                                        onTap: () {
                                          AppMetrica.reportEvent(
                                              'Open Information Banners');
                                          JSONValue()[index].isClick!
                                              ? JSONValue()[index].type !=
                                                      'website'
                                                  ? Get.to(DetalNews(
                                                      newData:
                                                          JSONValue()[index]))
                                                  : JSONValue()[index]
                                                              .websiteUrl !=
                                                          ''
                                                      ? launchUrl(
                                                          Uri.parse(
                                                              JSONValue()[index]
                                                                  .websiteUrl!),
                                                          mode: LaunchMode
                                                              .inAppWebView)
                                                      : null
                                              : null;
                                        },
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl:
                                                  JSONValue()[index].imageUrl!,
                                            ),
                                            JSONValue()[index].isClick!
                                                ? Positioned(
                                                    right: 10,
                                                    bottom: 10,
                                                    child: Text(
                                                      "Нажмите для просмотра",
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              JSONValue()[index]
                                                                  .textColorClick!))),
                                                    ))
                                                : SizedBox()
                                          ],
                                        ),
                                      )
                                    : SizedBox()),
                          ),
                        ),

                  // ),
                  JSONValue().length > 1
                      ? Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: activePage,
                              count: JSONValue().length,
                              // textDirection: TextDirection(),
                              effect: WormEffect(
                                  dotColor: Colors.white.withOpacity(0.4),
                                  activeDotColor: Colors.white.withOpacity(0.9),
                                  dotWidth: 6,
                                  dotHeight: 6),
                            ),
                          ))
                      : SizedBox(),
                ],
              );
            }));
  }
}
