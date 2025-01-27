import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../core/data/tonalityAkkords.dart';
import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';
import '../../core/data/akkords.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  bool isTonality = false;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.right,
        color: colorFiolet.withValues(alpha: 0.3),
        child: DefaultTabController(
          key: ValueKey(isTonality),
          initialIndex: 0,
          length: isTonality ? tonalityAkkords.length : tabs.length,
          child: Scaffold(
              body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Text(tr(LocaleKeys.appbar_chords)),
                forceElevated: innerBoxIsScrolled,
                snap: false,
                floating: true,
                pinned: false,
                backgroundColor: Colors.transparent,
                foregroundColor:
                    Theme.of(context).primaryTextTheme.titleMedium!.color,
                elevation: 0,
                actions: [
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        showModalBottomSheet(
                            // useSafeArea: ,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            builder: (context) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 16),
                                        child: Text(
                                          "Изменение группировки",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                          onTap: () {
                                            setState(() {
                                              isTonality = true;
                                            });
                                            Get.back();
                                          },
                                          trailing: isTonality == true
                                              ? const Icon(Icons.check)
                                              : null,
                                          title: const Text("По тональности")),
                                      ListTile(
                                          onTap: () {
                                            setState(() {
                                              isTonality = false;
                                            });
                                            Get.back();
                                          },
                                          trailing: isTonality == false
                                              ? const Icon(Icons.check)
                                              : null,
                                          title: const Text(
                                              "По буквам аппликатуры")),
                                    ],
                                  ),
                                ));
                      },
                      icon: const Icon(
                        Bootstrap.three_dots_vertical,
                        size: 20,
                      )),
                ],
                bottom: TabBar(
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  isScrollable: isTonality,
                  tabs: isTonality
                      ? tonalityAkkords
                          .map((tab) => Tab(
                                text: tab.name,
                              ))
                          .toList()
                      : tabs
                          .map((tab) => Tab(
                                text: tab,
                              ))
                          .toList(),
                ),
                // backgroundColor: Colors.white,
              ),
            ],
            body: TabBarView(
                children: isTonality
                    ? tonalityAkkords.map((tonality) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          physics: const BouncingScrollPhysics(),
                          itemCount: tonality.akkord.length + 1,
                          itemBuilder: (context, index) {
                            if (index == tonality.akkord.length) {
                              return Column(
                                children: [
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Дополнительные аккорды",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                      children: tonality.addAkkord
                                          .map(
                                            (addedAkkord) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${addedAkkord.name} ${addedAkkord.barre ? "(${Localizations.localeOf(context).languageCode == "ru" ? "баррэ" : "barre"})" : ""}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SvgPicture.asset(
                                                    Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? addedAkkord.imageDark!
                                                        : addedAkkord.image!,
                                                    height: 300,
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList()),
                                ],
                              );
                            }
                            final akkord = tonality.akkord[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${akkord.name} ${akkord.barre ? "(${Localizations.localeOf(context).languageCode == "ru" ? "баррэ" : "barre"})" : ""}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  const SizedBox(height: 10),
                                  SvgPicture.asset(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? akkord.imageDark!
                                        : akkord.image!,
                                    height: 300,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList()
                    : tabs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final filteredAkkords = akkordsList
                            .where((akkord) => akkord.index == index)
                            .toList();
                        return filteredAkkords.isNotEmpty
                            ? !context.isDarkMode
                                ? ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: filteredAkkords.length,
                                    itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Text(
                                              "${filteredAkkords[index].name} ${filteredAkkords[index].barre ? "(${context.locale == const Locale('ru') ? "баррэ" : "barre"})" : ""}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SvgPicture.asset(
                                              filteredAkkords[index].image!,
                                              height: 300,
                                            )
                                          ]),
                                        ))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: filteredAkkords.length,
                                    itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            Text(
                                              "${filteredAkkords[index].name} ${filteredAkkords[index].barre ? "(${context.locale == const Locale('ru') ? "баррэ" : "barre"})" : ""}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SvgPicture.asset(
                                              filteredAkkords[index].imageDark!,
                                              height: 300,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ))
                            : const SizedBox();
                      }).toList()),
          )),
        ),
      ),
    );
  }
}
