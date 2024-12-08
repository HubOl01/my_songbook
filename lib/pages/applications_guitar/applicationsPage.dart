import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locale_keys.g.dart';
import 'akkords.dart';
import 'applicationsController.dart';

class ApplicationsPage extends GetView<ApplicationsController> {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(tr(LocaleKeys.appbar_chords)),
                  forceElevated: innerBoxIsScrolled,
                  snap: false,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Theme.of(context).primaryTextTheme.titleMedium!.color,
                  elevation: 0,
                  // backgroundColor: Colors.white,
                ),
              ],
          body: SafeArea(
      child: !context.isDarkMode
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: context.locale == const Locale('ru')
                      ? akkordsListRU.length
                      : akkordsListEN.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            context.locale == const Locale('ru')
                                ? akkordsListRU[index].name
                                : akkordsListEN[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            context.locale == const Locale('ru')
                                ? akkordsListRU[index].url_image
                                : akkordsListEN[index].url_image,
                            height: 300,
                          )
                        ]),
                      ))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: context.locale == const Locale('ru')
                      ? akkordsListDarkRU.length
                      : akkordsListDarkEN.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            context.locale == const Locale('ru')
                                ? akkordsListDarkRU[index].name
                                : akkordsListDarkEN[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            context.locale == const Locale('ru')
                                ? akkordsListDarkRU[index].url_image
                                : akkordsListDarkEN[index].url_image,
                            height: 300,
                          )
                        ]),
                      ))),
    ));
  }
}
