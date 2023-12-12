import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/guitar_songs/search/searchPageController.dart';

import '../guitarDetal.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Container(
            padding: EdgeInsets.only(right: 4, top: 6, bottom: 6),
            width: context.width - 65,
            child: TextField(
              onChanged: (value) => controller.searchSong(value),
              autofocus: true,
              controller: searchController,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6),
                filled: true,
                fillColor: Colors.white.withOpacity(.3),
                hintText: "Трек, исполнитель",
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 18,
                    decoration: TextDecoration.none),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
              ),
              maxLines: 1,
            ),
          )
        ]),
        body: Obx(()=> ListView.builder(
          itemCount: controller.searchedSong.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(controller.searchedSong[index].name_song,
                      style: TextStyle(fontSize: 16)),
                  Text(
                    "${controller.searchedSong[index].name_singer}",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              onTap: () {
                Get.to(GuitarDetal(
                  id: controller.searchedSong[index].id,
                ));
              },
            );
          },
        )));
  }
}

TextEditingController searchController = TextEditingController();
final SearchPageController controller = Get.put(SearchPageController());
