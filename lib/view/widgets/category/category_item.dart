import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../res/custom_widgets/custom_container.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../../models/category_model.dart';
import '../../../view/categories/category_products_screen.dart';
import '../../../res/components/components.dart';
import '../../../utils/utils.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryItem({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.navigateTo(
          widget: CategoryProductsScreen(
            categoryName: categoryModel.title,
          ),
          context: context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CustomContainer(
          child: Row(
            children: [
              SvgPicture.asset(
                categoryModel.img,
                width: MediaQuery.of(context).size.width * .2,
              ),
              const SpaceWidth(),
              BodyLargeText(categoryModel.title),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward_ios_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
