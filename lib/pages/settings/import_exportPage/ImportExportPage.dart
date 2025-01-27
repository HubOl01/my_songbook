import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/bloc/songs_bloc.dart';
import '../../../core/styles/colors.dart';
import '../../../core/utils/backup.dart';
import '../../../core/utils/import.dart';
import '../../../core/utils/restore.dart';
import '../../../generated/locale_keys.g.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.data_export_import_title)),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: colorFiolet.withValues(alpha: 0.3),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  minLeadingWidth: 25,
                  leading: SvgPicture.asset(
                    "assets/icon/clarity_backup-line.svg",
                    alignment: Alignment.center,
                    width: 25,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                  ),
                  title: Text(tr(LocaleKeys.data_backup)),
                  onTap: () async {
                    AppMetrica.reportEvent('data_backup');
                    createBackup(context);

                    // await createBackup();
                  },
                ),
                ListTile(
                  minLeadingWidth: 25,
                  leading: SvgPicture.asset(
                      "assets/icon/clarity_backup-restore-line.svg",
                      alignment: Alignment.center,
                      width: 25,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).iconTheme.color!, BlendMode.srcIn)),
                  title: Text("${tr(LocaleKeys.data_restore)} (.zip)"),
                  onTap: () async {
                    AppMetrica.reportEvent('data_restore');
                    await restoreBackup(context);
                    context.read<SongsBloc>().add(LoadSongs());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Добавление отдельных песен",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  minLeadingWidth: 25,
                  leading: SvgPicture.asset(
                      "assets/icon/clarity_import-line.svg",
                      alignment: Alignment.center,
                      width: 25,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).iconTheme.color!, BlendMode.srcIn)),
                  title: Text("${tr(LocaleKeys.data_import)} (.zip)"),
                  onTap: () async {
                    AppMetrica.reportEvent('data_import');
                    await importSongs(context);
                    context.read<SongsBloc>().add(LoadSongs());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
