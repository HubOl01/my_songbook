import 'package:flutter/material.dart';

import '../core/styles/colors.dart';

class PremListTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const PremListTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle,
        color: colorFiolet,
        // size: 30,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      minLeadingWidth: 0,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
