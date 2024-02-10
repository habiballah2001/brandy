import 'package:flutter/material.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import '../../../res/constants/constants.dart';
import '../category/category_item_circle.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicHeightGridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: Lists.categoriesList(context: context).length,
      builder: (context, index) => CategoryItemCircle(
        categoryModel: Lists.categoriesList(context: context)[index],
      ),
    );
  }
}
