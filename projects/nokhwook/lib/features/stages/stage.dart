import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:nokhwook/components/fixable_floating_action_button.dart';
import 'package:nokhwook/features/welcome/memorized_subset.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/components/word_board.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Stage extends StatefulWidget {
  final String title;
  final double? playSpeed;
  final List<int>? subset;

  const Stage({super.key, required this.title, this.playSpeed, this.subset});

  @override
  State<Stage> createState() => _StageState();
}

class _StageState extends State<Stage> {
  final visibilityKey = const Key('visibilityKey');
  final controller = SwiperController();

  late Vocab vocab;

  bool autoPlaying = false;

  @override
  void initState() {
    super.initState();

    vocab = context.read<Vocab>();
  }

  @override
  void didUpdateWidget(covariant Stage oldWidget) {
    super.didUpdateWidget(oldWidget);
    stopAutoplay();

    logger.i('didUpdateWidget: Subset: ${widget.subset}'
        ' Speed: ${widget.playSpeed}');
  }

  stopAutoplay() {
    controller.stopAutoplay();
    setState(() {
      autoPlaying = false;
    });
  }

  startAutoplay() {
    controller.startAutoplay();
    setState(() {
      autoPlaying = true;
    });
  }

  Widget buildItem(index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: WordBoard(
          header: vocab.header,
          word: vocab[index],
          memorize: () {},
        ),
      );

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SharedPreferences>();
    final memorizedSubset = MemorizedSubset(prefs);

    return VisibilityDetector(
      onVisibilityChanged: (info) =>
          info.visibleFraction < 0.1 ? stopAutoplay() : null,
      key: visibilityKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Swiper(
                      itemCount: (widget.subset ?? []).length,
                      outer: true,
                      autoplayDelay: ((widget.playSpeed ?? 0.1) * 1000).toInt(),
                      controller: controller,
                      itemBuilder: (context, index) {
                        final controller = ScrollController();

                        return RawScrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            interactive: true,
                            radius: const Radius.circular(8.0),
                            controller: controller,
                            child: SingleChildScrollView(
                                controller: controller,
                                physics: const BouncingScrollPhysics(),
                                child: buildItem(widget.subset![index])));
                      },
                      pagination: SwiperPagination(
                          builder: SwiperCustomPagination(
                        builder: (context, config) => Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(
                                    builder: ((context) => IconButton(
                                          onPressed: () {
                                            memorizedSubset.append(widget
                                                .subset![config.activeIndex]);
                                            controller.next();
                                          },
                                          icon: Icon(Icons.save,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ))),
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: FractionPaginationBuilder(
                                          color:
                                              Theme.of(context).disabledColor,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          activeFontSize: 20.0)
                                      .build(context, config),
                                )
                              ]),
                        ),
                      ))),
                )
              ]),
            ),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Card(
            //       elevation: 2.0,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //       margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            //       child: Column(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 8.0),
            //             child: Text(
            //               widget.title.toUpperCase(),
            //               style: Theme.of(context).textTheme.titleMedium,
            //             ),
            //           ),
            //           Expanded(
            //             child: Swiper(
            //               allowImplicitScrolling: true,
            //               indicatorLayout: PageIndicatorLayout.SCALE,
            //               itemCount: (widget.subset ?? []).length,
            //               autoplayDelay: ((widget.playSpeed ?? 0.1) * 1000).toInt(),
            //               controller: controller,
            //               itemBuilder: (context, index) =>
            //                   buildItem(widget.subset![index]),
            //               pagination: SwiperCustomPagination(
            //                 builder: (context, config) => Align(
            //                   alignment: Alignment.bottomLeft,
            //                   child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Builder(
            //                             builder: ((context) => IconButton(
            //                                   onPressed: () {
            //                                     memorizedSubset.append(widget
            //                                         .subset![config.activeIndex]);
            //                                     controller.next();
            //                                   },
            //                                   icon: Icon(Icons.save,
            //                                       color: Theme.of(context)
            //                                           .colorScheme
            //                                           .primary),
            //                                 ))),
            //                         Container(
            //                           margin: const EdgeInsets.only(right: 8.0),
            //                           child: FractionPaginationBuilder(
            //                                   color:
            //                                       Theme.of(context).disabledColor,
            //                                   activeColor: Theme.of(context)
            //                                       .colorScheme
            //                                       .secondary,
            //                                   activeFontSize: 20.0)
            //                               .build(context, config),
            //                         )
            //                       ]),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: Container(),
            //           )
            //         ],
            //       ),
            //     ),
            //     if (widget.playSpeed != null)
            //       FixableFloatingActionButton(
            //         onPressed: () => autoPlaying ? stopAutoplay() : startAutoplay(),
            //         child: autoPlaying
            //             ? const Icon(Icons.pause_circle)
            //             : const Icon(Icons.play_circle),
            //       ),
            //   ],
            // ),
          ),
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Expanded(flex: 3, child: Container()),
          if (widget.playSpeed != null)
            FixableFloatingActionButton(
              onPressed: () => autoPlaying ? stopAutoplay() : startAutoplay(),
              child: autoPlaying
                  ? const Icon(Icons.pause_circle)
                  : const Icon(Icons.play_circle),
            ),
        ],
      ),
    );
  }
}
