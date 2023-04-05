import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class LocalSwiper extends StatelessWidget {
  const LocalSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: 5,
      outer: true,
      itemBuilder: (context, index) {
        final controller = ScrollController();

        return RawScrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          thumbColor: Theme.of(context).primaryColor,
          radius: const Radius.circular(8.0),
          controller: controller,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: controller,
            child: Column(
              children: List.generate(index + 45, (ii) => Text('$ii')),
            ),
          ),
        );
      },
      pagination: SwiperPagination(
          builder: SwiperCustomPagination(
              builder: (context, config) => Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => {}, icon: Icon(Icons.abc_outlined))
                    ],
                  )))),
    );
  }
}
