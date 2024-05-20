import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:orre_web/presenter/storeinfo/menu/store_info_screen_menu_list_widget.dart';
import 'package:orre_web/widget/text/text_widget.dart';

import '../../../../model/store_info_model.dart';

class StoreMenuCategoryTileWidget extends ConsumerWidget {
  final StoreDetailInfo storeDetailInfo;

  const StoreMenuCategoryTileWidget({super.key, required this.storeDetailInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuCategories = storeDetailInfo.menuCategories;
    final categoryKR = menuCategories.getCategories();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryKR.length,
      itemBuilder: (context, index) {
        final category = categoryKR[index];
        // print("category: $category");
        final categoryCode = menuCategories.categories.keys.firstWhere(
          (key) => menuCategories.categories[key] == category,
          orElse: () => '',
        );
        // print("categoryCode: $categoryCode");
        return Material(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 8.r,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFFFB74D)),
                    SizedBox(
                      width: 5.r,
                    ),
                    TextWidget(category,
                        fontSize: 24.r,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFB74D)),
                    SizedBox(
                      width: 5.r,
                    ),
                    const Icon(Icons.auto_awesome, color: Color(0xFFFFB74D)),
                  ],
                ),
              ),
              SizedBox(
                height: 8.r,
              ),
              StoreMenuListWidget(
                storeDetailInfo: storeDetailInfo,
                category: categoryCode,
              ),
              SizedBox(
                height: 8.r,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: const Color(0xFFDFDFDF),
        thickness: 2.r,
        endIndent: 10.r,
        indent: 10.r,
      ),
    );
  }
}
