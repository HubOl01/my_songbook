import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class NoDataSongsGroup extends StatelessWidget {
  const NoDataSongsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      tr(LocaleKeys.no_data_folder),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16),
    ));
  }
}
