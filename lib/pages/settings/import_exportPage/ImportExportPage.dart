import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_songbook/components/customButton.dart';

import '../../../core/api/variable_firebase.dart';
import '../../../core/bloc/songs_bloc.dart';
import '../../../core/utils/backup.dart';
import '../../../core/utils/import.dart';
import '../../../generated/locale_keys.g.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.data_export_import_title)),
      ),
      body: Column(
        children: [
          FutureBuilder<bool>(
              future: getBetaData(),
              builder: (context, snapshot) {
                return snapshot.data! != true
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "С новой версии приложения теперь доступны функции экспорта и импорта данных. Поскольку они находятся в стадии бета-тестирования, вы можете пройти анкетирование здесь.",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            onPressed: () {
                              // launchUrl("", mode: LaunchMode.inAppBrowserView);
                            },
                            child: const Text(
                              "Пройти анкетирование",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
              }),
          ListTile(
            leading: const Icon(MingCute.file_export_line),
            title: Text(tr(LocaleKeys.data_export)),
            onTap: () async {
              AppMetrica.reportEvent('data_export');
              await createBackup(context);

              // await createBackup();
            },
          ),
          ListTile(
            leading: const Icon(MingCute.file_import_line),
            title: Text("${tr(LocaleKeys.data_import)} (.zip)"),
            onTap: () async {
              AppMetrica.reportEvent('data_import');
              await importBackup();
              context.read<SongsBloc>().add(LoadSongs());
            },
          ),
        ],
      ),
    );
  }
}