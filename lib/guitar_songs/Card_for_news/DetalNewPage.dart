import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetalNewPage extends StatelessWidget {
  final imageUrl;
  const DetalNewPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Итоги года"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [CachedNetworkImage(imageUrl: imageUrl), Text("")],
        ),
      ),
    );
  }
}
