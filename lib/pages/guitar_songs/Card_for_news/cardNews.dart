import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/news.dart';
import '../../../core/cubit/hide_banner_id_cubit.dart';
import '../../../core/model/newsModel.dart';
import 'ListEvent.dart';
import 'ListPro.dart';
import 'ListStar.dart';

class CardNews extends StatelessWidget {
  final bool showBanner;
  final Function() onClose;
  const CardNews({super.key, required this.showBanner, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NewsModel?>(
        future: NewsService().getNews(),
        builder: (context, snapshot) {
          bool shouldShowBanner = showBanner &&
              snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null;

          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: shouldShowBanner
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: snapshot.hasData && snapshot.data != null
                ? snapshot.data!.isStarred!
                    ? ListStar(
                        onClose: () {
                          context
                              .read<HideBannerIdCubit>()
                              .hide(snapshot.data!.id!);
                          onClose();
                        },
                      )
                    : snapshot.data!.isPremium!
                        ? ListPro(
                            model: snapshot.data!,
                            onClose: () {
                              context
                                  .read<HideBannerIdCubit>()
                                  .hide(snapshot.data!.id!);
                              onClose();
                            },
                          )
                        : ListEvent(
                            news: snapshot.data!,
                            onClose: () {
                              context
                                  .read<HideBannerIdCubit>()
                                  .hide(snapshot.data!.id!);
                              onClose();
                            },
                          )
                : const SizedBox(),
            secondChild: const SizedBox(),
          );
        });
  }
}
