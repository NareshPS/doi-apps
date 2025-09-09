import 'package:flutter/material.dart';
import 'package:nokhwook/features/stages/stage.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/models/word.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 1
mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  bool get isOverlayShown => _overlayEntry != null;

  void toggleOverlay(Widget child) =>
      isOverlayShown ? removeOverlay() : insertOverlay(child);

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void insertOverlay(child) {
    _overlayEntry = OverlayEntry(builder: (_) => dismissibleOverlay(child));

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget dismissibleOverlay(Widget child) {
    final box = context.findAncestorRenderObjectOfType() as RenderBox;
    return Positioned.fill(
      left: box.localToGlobal(Offset.zero).dx,
      top: box.localToGlobal(Offset.zero).dy,
      child: GestureDetector(
        onTap: removeOverlay,
        child: Container(
            color: Theme.of(context)
                .scaffoldBackgroundColor
                .withValues(alpha: 0.75),
            child: child),
      ),
    );
  }
}

class WordGridItem extends StatelessWidget {
  final List<String> header;
  final Word word;
  const WordGridItem({super.key, required this.header, required this.word});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(word.items[0].phrase,
              style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );
  }
}

class WordGrid extends StatefulWidget {
  final String title;
  final List<int> subset;
  final Vocab vocab;

  const WordGrid(
      {super.key,
      required this.title,
      required this.vocab,
      required this.subset});

  @override
  State<WordGrid> createState() => _WordGridState();
}

class _WordGridState extends State<WordGrid> with OverlayStateMixin {
  @override
  void didChangeDependencies() {
    removeOverlay();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: ResponsiveGridRow(
            children: widget.subset
                .map((index) => ResponsiveGridCol(
                    xs: 4,
                    child: GestureDetector(
                      onTap: () {
                        toggleOverlay(
                            Stage(title: widget.title, subset: widget.subset));
                      },
                      child: WordGridItem(
                          header: widget.vocab.header,
                          word: widget.vocab[index]),
                    )))
                .toList()),
      ),
    );
  }
}
