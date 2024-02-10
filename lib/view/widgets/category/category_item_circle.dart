import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/category_model.dart';
import '../../../view/categories/category_products_screen.dart';
import '../../../utils/utils.dart';
import '../../../res/custom_widgets/custom_texts.dart';

class CategoryItemCircle extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryItemCircle({
    super.key,
    required this.categoryModel,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.navigateTo(
            widget: CategoryProductsScreen(categoryName: categoryModel.title),
            context: context);
      },
      child: SizedBox(
        width: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              child: SvgPicture.asset(
                categoryModel.img,
              ),
            ),
            BodySmallText(
              categoryModel.title,
              maxLines: 1,
              overFlow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
