import 'dart:math';

import 'package:flutter/material.dart' hide CarouselController;
import '../../../core/api/news.dart';
import '../../../core/model/newsModel.dart';
import '../../../core/storage/storage.dart';
import 'ListEvent.dart';

class CardNews extends StatefulWidget {
  final Function(double height) onHeightChanged;
  final Function(bool hasContent) onContentChanged;

  const CardNews({
    super.key,
    required this.onHeightChanged,
    required this.onContentChanged,
  });

  @override
  State<CardNews> createState() => _CardNewsState();
}

class _CardNewsState extends State<CardNews> {
  late Future<List<NewsModel>> newsFuture;

  @override
  void initState() {
    super.initState();
    newsFuture = JSONValueRU();
  }

  void reloadNews() async {
    setState(() {
      newsFuture = JSONValueRU();
    });

    await newsFuture;

    if (mounted) {
      widget.onHeightChanged(0); // Сброс высоты
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateHeight();
      });
    }
  }

  void updateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        widget.onHeightChanged(renderBox.size.height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(),
      builder: (context, snapshot) {
        return FutureBuilder<List<NewsModel>>(
          future: JSONValueRU(),
          builder: (context, jsonSnapshot) {
            final hasData =
                jsonSnapshot.hasData && jsonSnapshot.data!.isNotEmpty;

            if (hasData) {
              final indexRU = Random().nextInt(jsonSnapshot.data!.length);
              final newsItem = jsonSnapshot.data![indexRU];

              WidgetsBinding.instance.addPostFrameCallback((_) {
                updateHeight();
              });

              return ListEvent(
                news: newsItem,
                onClick: () async {
                  await BannerManager()
                      .closeBanner(true, idBanner: newsItem.id);

                  reloadNews();
                },
                onClose: () async {
                  await BannerManager()
                      .closeBanner(true, idBanner: newsItem.id);
                  reloadNews();
                },
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onHeightChanged(0);
                widget.onContentChanged(false);
              });
              return const SizedBox.shrink(); // Пустой виджет
            }
          },
        );
      },
    );
  }
}

// class _CardNewsState extends State<CardNews> {
//   bool showBannerStar = true;
//   BannerManager banner = BannerManager();

//   late Future<List<NewsModel>> newsFuture;

//   @override
//   void initState() {
//     super.initState();
//     newsFuture = JSONValueRU();
//   }

//   void reloadNews() async {
//     setState(() {
//       newsFuture = JSONValueRU();
//     });

//     await newsFuture;

//     if (mounted) {
//       widget.updateCardHeight();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     widget.updateCardHeight();

//     return FutureBuilder(
//       future: getNews(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SizedBox();
//         }

//         if (snapshot.hasError) {
//           return const SizedBox();
//         }

//         return FutureBuilder<List<NewsModel>>(
//           future: JSONValueRU(),
//           builder: (context, jsonSnapshot) {
//             if (jsonSnapshot.hasData && jsonSnapshot.data!.isNotEmpty) {
//               final indexRU = Random().nextInt(jsonSnapshot.data!.length);
//               final newsItem = jsonSnapshot.data![indexRU];

//               return ListEvent(
//                 news: newsItem,
//                 onClick: () async {
//                    await BannerManager()
//                       .closeBanner(true, idBanner: newsItem.id);

//                   reloadNews();
//                 },
//                 onClose: () async {
//                   await BannerManager()
//                       .closeBanner(true, idBanner: newsItem.id);

//                   reloadNews();
//                 },
//               );
//             }

//             return const SizedBox();
//           },
//         );
//       },
//     );
//   }
// }



  //   return FutureBuilder(
  //       future: getNews(),
  //       builder: (context, snapshot) {
  //         widget.updateCardHeight();
  //         return context.locale == const Locale('ru')
  //             ? JSONValueRU().isEmpty
  //                 ? const SizedBox()
  //                 : banner.shouldShowBanner(JSONValueRU()[indexRU].id!) ? const SizedBox() :  ListEvent(
  //                     news: JSONValueRU()[indexRU],
  //                     onClose: () async {
  //                       widget.updateCardHeight();
  //                       BannerManager banner = BannerManager();
  //                       await banner.closeBanner(
  //                         true,
  //                         idBanner: JSONValueRU()[indexRU].id,
  //                       );
  //                     },
  //                   )
  //             : const SizedBox();
  //       });
  // }


          // Stack(
          //   children: [
          //     context.locale == const Locale('ru')
          //         ? JSONValueRU().isEmpty
          //             ? const SizedBox()
          //             : context.isLandscape
          //                 ? SizedBox(
          //                     height: context.width / 3.6,
          //                     child: ListView.builder(
          //                       scrollDirection: Axis.horizontal,
          //                       itemCount: JSONValueRU().length,
          //                       itemBuilder: (context, index) => Padding(
          //                         padding: const EdgeInsets.all(2.0),
          //                         child: ClipRRect(
          //                             borderRadius:
          //                                 BorderRadius.circular(10),
          //                             child:
          //                                 JSONValueRU()[index].imageUrl !=
          //                                         ''
          //                                     ? GestureDetector(
          //                                         onTap: () {
          //                                           AppMetrica.reportEvent(
          //                                               'Open Information Banners');
          //                                           JSONValueRU()[index]
          //                                                   .isClick!
          //                                               ? JSONValueRU()[index]
          //                                                           .type !=
          //                                                       'website'
          //                                                   ? Get.to(DetalNews(
          //                                                       newData:
          //                                                           JSONValueRU()[
          //                                                               index]))
          //                                                   : JSONValueRU()[index]
          //                                                               .websiteUrl !=
          //                                                           ''
          //                                                       ? launchUrl(
          //                                                           Uri.parse(JSONValueRU()[index]
          //                                                               .websiteUrl!),
          //                                                           mode: LaunchMode
          //                                                               .inAppWebView)
          //                                                       : null
          //                                               : null;
          //                                         },
          //                                         child: Stack(
          //                                           children: [
          //                                             CachedNetworkImage(
          //                                               imageUrl:
          //                                                   JSONValueRU()[
          //                                                           index]
          //                                                       .imageUrl!,
          //                                             ),
          //                                           ],
          //                                         ),
          //                                       )
          //                                     : const SizedBox()),
          //                       ),
          //                     ),
          //                   )
          //                 : CarouselSlider.builder(
          //                     controller: _controller,
          //                     itemCount: JSONValueRU().length,
          //                     options: CarouselOptions(
          //                         aspectRatio: 16 / 9,
          //                         enableInfiniteScroll: false,
          //                         viewportFraction: 1,
          //                         // enlargeCenterPage: true,
          //                         autoPlay: JSONValueRU().length > 1
          //                             ? true
          //                             : false,
          //                         autoPlayInterval:
          //                             const Duration(seconds: 15),
          //                         onPageChanged: (index, reason) {
          //                           setState(() {
          //                             activePage = index;
          //                           });
          //                         }),
          //                     itemBuilder: (context, index, realIndex) =>
          //                         Padding(
          //                       padding: const EdgeInsets.all(2.0),
          //                       child: ClipRRect(
          //                           borderRadius: BorderRadius.circular(10),
          //                           child:
          //                               JSONValueRU()[index].imageUrl != ''
          //                                   ? GestureDetector(
          //                                       onTap: () {
          //                                         AppMetrica.reportEvent(
          //                                             'Open Information Banners ${JSONValueRU()[index].type}');
          //                                         JSONValueRU()[index]
          //                                                 .isClick!
          //                                             ? JSONValueRU()[index]
          //                                                         .type !=
          //                                                     'website'
          //                                                 ? Get.to(DetalNews(
          //                                                     newData:
          //                                                         JSONValueRU()[
          //                                                             index]))
          //                                                 : JSONValueRU()[index]
          //                                                             .websiteUrl !=
          //                                                         ''
          //                                                     ? launchUrl(
          //                                                         Uri.parse(
          //                                                             JSONValueRU()[index]
          //                                                                 .websiteUrl!),
          //                                                         mode: LaunchMode
          //                                                             .inAppWebView)
          //                                                     : null
          //                                             : null;
          //                                       },
          //                                       child: Stack(
          //                                         children: [
          //                                           CachedNetworkImage(
          //                                             imageUrl:
          //                                                 JSONValueRU()[
          //                                                         index]
          //                                                     .imageUrl!,
          //                                           ),
          //                                           JSONValueRU()[index]
          //                                                   .isClick!
          //                                               ? Positioned(
          //                                                   right: 10,
          //                                                   bottom: 10,
          //                                                   child: Text(
          //                                                     "Нажмите для просмотра",
          //                                                     style: TextStyle(
          //                                                         color: Color(
          //                                                             int.parse(
          //                                                                 JSONValueRU()[index].textColorClick!))),
          //                                                   ))
          //                                               : const SizedBox()
          //                                         ],
          //                                       ),
          //                                     )
          //                                   : const SizedBox()),
          //                     ),
          //                   )
          //         : JSONValueEN().isEmpty
          //             ? const SizedBox()
          //             : context.isLandscape
          //                 ? SizedBox(
          //                     height: context.width / 3.6,
          //                     child: ListView.builder(
          //                       scrollDirection: Axis.horizontal,
          //                       itemCount: JSONValueEN().length,
          //                       itemBuilder: (context, index) => Padding(
          //                         padding: const EdgeInsets.all(2.0),
          //                         child: ClipRRect(
          //                             borderRadius:
          //                                 BorderRadius.circular(10),
          //                             child:
          //                                 JSONValueEN()[index].imageUrl !=
          //                                         ''
          //                                     ? GestureDetector(
          //                                         onTap: () {
          //                                           AppMetrica.reportEvent(
          //                                               'Open Information Banners');
          //                                           JSONValueEN()[index]
          //                                                   .isClick!
          //                                               ? JSONValueEN()[index]
          //                                                           .type !=
          //                                                       'website'
          //                                                   ? Get.to(DetalNews(
          //                                                       newData:
          //                                                           JSONValueEN()[
          //                                                               index]))
          //                                                   : JSONValueEN()[index]
          //                                                               .websiteUrl !=
          //                                                           ''
          //                                                       ? launchUrl(
          //                                                           Uri.parse(JSONValueEN()[index]
          //                                                               .websiteUrl!),
          //                                                           mode: LaunchMode
          //                                                               .inAppWebView)
          //                                                       : null
          //                                               : null;
          //                                         },
          //                                         child: Stack(
          //                                           children: [
          //                                             CachedNetworkImage(
          //                                               imageUrl:
          //                                                   JSONValueEN()[
          //                                                           index]
          //                                                       .imageUrl!,
          //                                             ),
          //                                             JSONValueEN()[index]
          //                                                     .isClick!
          //                                                 ? Positioned(
          //                                                     right: 10,
          //                                                     bottom: 10,
          //                                                     child: Text(
          //                                                       "Click to view",
          //                                                       style: TextStyle(
          //                                                           color: Color(
          //                                                               int.parse(JSONValueEN()[index].textColorClick!))),
          //                                                     ))
          //                                                 : const SizedBox()
          //                                           ],
          //                                         ),
          //                                       )
          //                                     : const SizedBox()),
          //                       ),
          //                     ),
          //                   )
          //                 : CarouselSlider.builder(
          //                     controller: _controller,
          //                     itemCount: JSONValueEN().length,
          //                     options: CarouselOptions(
          //                         aspectRatio: 16 / 9,
          //                         enableInfiniteScroll: false,
          //                         viewportFraction: 1,
          //                         autoPlay: JSONValueEN().length > 1
          //                             ? true
          //                             : false,
          //                         autoPlayInterval:
          //                             const Duration(seconds: 15),
          //                         onPageChanged: (index, reason) {
          //                           setState(() {
          //                             activePage = index;
          //                           });
          //                         }),
          //                     itemBuilder: (context, index, realIndex) =>
          //                         Padding(
          //                       padding: const EdgeInsets.all(2.0),
          //                       child: ClipRRect(
          //                           borderRadius: BorderRadius.circular(10),
          //                           child:
          //                               JSONValueEN()[index].imageUrl != ''
          //                                   ? GestureDetector(
          //                                       onTap: () {
          //                                         AppMetrica.reportEvent(
          //                                             'Open Information Banners ${JSONValueRU()[index].type}');
          //                                         JSONValueEN()[index]
          //                                                 .isClick!
          //                                             ? JSONValueEN()[index]
          //                                                         .type !=
          //                                                     'website'
          //                                                 ? Get.to(DetalNews(
          //                                                     newData:
          //                                                         JSONValueEN()[
          //                                                             index]))
          //                                                 : JSONValueEN()[index]
          //                                                             .websiteUrl !=
          //                                                         ''
          //                                                     ? launchUrl(
          //                                                         Uri.parse(
          //                                                             JSONValueEN()[index]
          //                                                                 .websiteUrl!),
          //                                                         mode: LaunchMode
          //                                                             .inAppWebView)
          //                                                     : null
          //                                             : null;
          //                                       },
          //                                       child: Stack(
          //                                         children: [
          //                                           CachedNetworkImage(
          //                                             imageUrl:
          //                                                 JSONValueEN()[
          //                                                         index]
          //                                                     .imageUrl!,
          //                                           ),
          //                                           JSONValueEN()[index]
          //                                                   .isClick!
          //                                               ? Positioned(
          //                                                   right: 10,
          //                                                   bottom: 10,
          //                                                   child: Text(
          //                                                     "Click to view",
          //                                                     style: TextStyle(
          //                                                         color: Color(
          //                                                             int.parse(
          //                                                                 JSONValueEN()[index].textColorClick!))),
          //                                                   ))
          //                                               : const SizedBox(),
          //                                         ],
          //                                       ),
          //                                     )
          //                                   : const SizedBox()),
          //                     ),
          //                   ),

          // // ),
          // context.isLandscape
          //     ? const SizedBox()
          //     : context.locale == const Locale('ru')
          //         ? JSONValueRU().length > 1
          //             ? Positioned(
          //                 bottom: 8,
          //                 left: 0,
          //                 right: 0,
          //                 child: Center(
          //                   child: AnimatedSmoothIndicator(
          //                     activeIndex: activePage,
          //                     count: JSONValueRU().length,
          //                     // textDirection: TextDirection(),
          //                     effect: WormEffect(
          //                         dotColor:
          //                             Colors.white.withOpacity(0.4),
          //                         activeDotColor:
          //                             Colors.white.withOpacity(0.9),
          //                         dotWidth: 6,
          //                         dotHeight: 6),
          //                   ),
          //                 ))
          //             : const SizedBox()
          //         : JSONValueEN().length > 1
          //             ? Positioned(
          //                 bottom: 8,
          //                 left: 0,
          //                 right: 0,
          //                 child: Center(
          //                   child: AnimatedSmoothIndicator(
          //                     activeIndex: activePage,
          //                     count: JSONValueEN().length,
          //                     // textDirection: TextDirection(),
          //                     effect: WormEffect(
          //                         dotColor:
          //                             Colors.white.withOpacity(0.4),
          //                         activeDotColor:
          //                             Colors.white.withOpacity(0.9),
          //                         dotWidth: 6,
          //                         dotHeight: 6),
          //                   ),
          //                 ))
          //             : const SizedBox(),
          //   ],
          // );