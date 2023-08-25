import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'akkords.dart';
import 'applicationsController.dart';

class ApplicationsPage extends GetView<ApplicationsController> {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      title: Text("Аккорды для гитары"),
                      forceElevated: innerBoxIsScrolled,
                      snap: false,
                      floating: true,
                      pinned: false,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      // backgroundColor: Colors.white,
                    ),
                  ],
              body: ListView.builder(
                physics: BouncingScrollPhysics(),
                  itemCount: akkordsList.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            akkordsList[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            akkordsList[index].url_image,
                            height: 300,
                          )
                        ]),
                      ))),
        ));
  }
}
