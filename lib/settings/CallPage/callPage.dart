import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Техподдержка"),
      ),
      body: ListView(
          padding: EdgeInsets.all(0),
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Вы можете обратиться в техподдержку через сообщество VK",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ),
            // Divider(),
            ListTile(
              title: Text("Написать лично"),
              onTap: () {
                launchUrl(
                  Uri.parse("https://vk.com/im?media=&sel=-222084855"),
                  mode: LaunchMode.externalApplication,
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 20,),
            ),
            // Divider(),
            ListTile(
              title: Text("Написать в обсуждениях"),
              onTap: () {
                launchUrl(
                  Uri.parse("https://vk.com/topic-222084855_49405611"),
                  mode: LaunchMode.externalApplication,
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
            ),
            // Divider(),
          ]),
    );
  }
}
