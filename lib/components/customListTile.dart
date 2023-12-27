import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool paddingBottom;
  const CustomListTile(
      {required this.title, required this.subtitle, required this.trailing, required this.paddingBottom});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: paddingBottom ? 8.0 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [title, subtitle],
          ),
          trailing
        ],
      ),
    );
  }
}
