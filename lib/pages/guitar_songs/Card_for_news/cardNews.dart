import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api/news.dart';
import 'detalNews.dart';

class CardNews extends StatefulWidget {
  CardNews({super.key});

  @override
  State<CardNews> createState() => _CardNewsState();
}

int activePage = 0;

class _CardNewsState extends State<CardNews> {
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder(
            future: getNews(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  context.locale == Locale('ru')
                      ? JSONValueRU().length == 0
                          ? SizedBox()
                          : context.isLandscape
                              ? SizedBox(
                                  height: context.width / 3.6,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: JSONValueRU().length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child:
                                              JSONValueRU()[index].imageUrl !=
                                                      ''
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        AppMetrica.reportEvent(
                                                            'Open Information Banners');
                                                        JSONValueRU()[index]
                                                                .isClick!
                                                            ? JSONValueRU()[index]
                                                                        .type !=
                                                                    'website'
                                                                ? Get.to(DetalNews(
                                                                    newData:
                                                                        JSONValueRU()[
                                                                            index]))
                                                                : JSONValueRU()[index]
                                                                            .websiteUrl !=
                                                                        ''
                                                                    ? launchUrl(
                                                                        Uri.parse(JSONValueRU()[index]
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
                                                                JSONValueRU()[
                                                                        index]
                                                                    .imageUrl!,
                                                          ),
                                                          JSONValueRU()[index]
                                                                  .isClick!
                                                              ? Positioned(
                                                                  right: 10,
                                                                  bottom: 10,
                                                                  child: Text(
                                                                    "Нажмите для просмотра",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            int.parse(JSONValueRU()[index].textColorClick!))),
                                                                  ))
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox()),
                                    ),
                                  ),
                                )
                              : CarouselSlider.builder(
                                  controller: _controller,
                                  itemCount: JSONValueRU().length,
                                  options: CarouselOptions(
                                      aspectRatio: 16 / 9,
                                      enableInfiniteScroll: false,
                                      viewportFraction: 1,
                                      // enlargeCenterPage: true,
                                      autoPlay: JSONValueRU().length > 1
                                          ? true
                                          : false,
                                      autoPlayInterval: Duration(seconds: 15),
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          activePage = index;
                                        });
                                      }),
                                  itemBuilder: (context, index, realIndex) =>
                                      Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            JSONValueRU()[index].imageUrl != ''
                                                ? GestureDetector(
                                                    onTap: () {
                                                      AppMetrica.reportEvent(
                                                          'Open Information Banners ${JSONValueRU()[index].type}');
                                                      JSONValueRU()[index]
                                                              .isClick!
                                                          ? JSONValueRU()[index]
                                                                      .type !=
                                                                  'website'
                                                              ? Get.to(DetalNews(
                                                                  newData:
                                                                      JSONValueRU()[
                                                                          index]))
                                                              : JSONValueRU()[index]
                                                                          .websiteUrl !=
                                                                      ''
                                                                  ? launchUrl(
                                                                      Uri.parse(
                                                                          JSONValueRU()[index]
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
                                                              JSONValueRU()[
                                                                      index]
                                                                  .imageUrl!,
                                                        ),
                                                        JSONValueRU()[index]
                                                                .isClick!
                                                            ? Positioned(
                                                                right: 10,
                                                                bottom: 10,
                                                                child: Text(
                                                                  "Нажмите для просмотра",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          int.parse(
                                                                              JSONValueRU()[index].textColorClick!))),
                                                                ))
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()),
                                  ),
                                )
                      : JSONValueEN().length == 0
                          ? SizedBox()
                          : context.isLandscape
                              ? SizedBox(
                                  height: context.width / 3.6,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: JSONValueEN().length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child:
                                              JSONValueEN()[index].imageUrl !=
                                                      ''
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        AppMetrica.reportEvent(
                                                            'Open Information Banners');
                                                        JSONValueEN()[index]
                                                                .isClick!
                                                            ? JSONValueEN()[index]
                                                                        .type !=
                                                                    'website'
                                                                ? Get.to(DetalNews(
                                                                    newData:
                                                                        JSONValueEN()[
                                                                            index]))
                                                                : JSONValueEN()[index]
                                                                            .websiteUrl !=
                                                                        ''
                                                                    ? launchUrl(
                                                                        Uri.parse(JSONValueEN()[index]
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
                                                                JSONValueEN()[
                                                                        index]
                                                                    .imageUrl!,
                                                          ),
                                                          JSONValueEN()[index]
                                                                  .isClick!
                                                              ? Positioned(
                                                                  right: 10,
                                                                  bottom: 10,
                                                                  child: Text(
                                                                    "Click to view",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            int.parse(JSONValueEN()[index].textColorClick!))),
                                                                  ))
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox()),
                                    ),
                                  ),
                                )
                              : CarouselSlider.builder(
                                  controller: _controller,
                                  itemCount: JSONValueEN().length,
                                  options: CarouselOptions(
                                      aspectRatio: 16 / 9,
                                      enableInfiniteScroll: false,
                                      viewportFraction: 1,
                                      autoPlay: JSONValueEN().length > 1
                                          ? true
                                          : false,
                                      autoPlayInterval: Duration(seconds: 15),
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          activePage = index;
                                        });
                                      }),
                                  itemBuilder: (context, index, realIndex) =>
                                      Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            JSONValueEN()[index].imageUrl != ''
                                                ? GestureDetector(
                                                    onTap: () {
                                                      AppMetrica.reportEvent(
                                                          'Open Information Banners ${JSONValueRU()[index].type}');
                                                      JSONValueEN()[index]
                                                              .isClick!
                                                          ? JSONValueEN()[index]
                                                                      .type !=
                                                                  'website'
                                                              ? Get.to(DetalNews(
                                                                  newData:
                                                                      JSONValueEN()[
                                                                          index]))
                                                              : JSONValueEN()[index]
                                                                          .websiteUrl !=
                                                                      ''
                                                                  ? launchUrl(
                                                                      Uri.parse(
                                                                          JSONValueEN()[index]
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
                                                              JSONValueEN()[
                                                                      index]
                                                                  .imageUrl!,
                                                        ),
                                                        JSONValueEN()[index]
                                                                .isClick!
                                                            ? Positioned(
                                                                right: 10,
                                                                bottom: 10,
                                                                child: Text(
                                                                  "Click to view",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          int.parse(
                                                                              JSONValueEN()[index].textColorClick!))),
                                                                ))
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()),
                                  ),
                                ),

                  // ),
                  context.isLandscape
                      ? SizedBox()
                      : context.locale == Locale('ru')
                          ? JSONValueRU().length > 1
                              ? Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: AnimatedSmoothIndicator(
                                      activeIndex: activePage,
                                      count: JSONValueRU().length,
                                      // textDirection: TextDirection(),
                                      effect: WormEffect(
                                          dotColor:
                                              Colors.white.withOpacity(0.4),
                                          activeDotColor:
                                              Colors.white.withOpacity(0.9),
                                          dotWidth: 6,
                                          dotHeight: 6),
                                    ),
                                  ))
                              : SizedBox()
                          : JSONValueEN().length > 1
                              ? Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: AnimatedSmoothIndicator(
                                      activeIndex: activePage,
                                      count: JSONValueEN().length,
                                      // textDirection: TextDirection(),
                                      effect: WormEffect(
                                          dotColor:
                                              Colors.white.withOpacity(0.4),
                                          activeDotColor:
                                              Colors.white.withOpacity(0.9),
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
